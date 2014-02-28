Router = {
  init: ()->
    # listeners
    Listeners.measurements()
    Listeners.viewPort()
    Listeners.router()
    Listeners.magnifier()

    #quiz
    Router.quiz.measurements()
    Router.quiz.listen()
    Router.quiz.magnify()
    Router.quiz.genetic($('#genetic_quiz'))
    Router.quiz.genetic($('#lice_quiz'))



    # populate sections and required interactions
    $('.content').each ()->
      currentSection = $(this).attr('data-section')

      # attachlistener
      Listeners.sectionInteractions(currentSection)


  route: (section)->
    console.log 'Incoming Section ', section
    Router.toggleSections(section)



  toggleSections: (el)->
    switch el
      when "#measurements" then $('#physical').removeClass('hidden')
      when "#step_2", "#step_2_conclusion" then el = "#genetic"
      when "#step_3"
        $('#physical').addClass('hidden')
        el = "#range"

      when "#step_4_conclusion"
        el = "#conclusion_2"

    # hide sections
    $('.section').addClass('hidden')
    # show active
    $(el).removeClass('hidden')

  quiz:

    measurements: ()->
      $quiz = $('#measurements_quiz')
      $quiz.find('.answers a').on(
        "click": (ev)->
          ev.preventDefault()
          isCorrect = $(this).hasClass('correct')
          switch isCorrect
            when true then $quiz.find('.correct').removeClass('hidden')
            else $quiz.find('.wrong').removeClass('hidden')

          $quiz.find('.pre').addClass('hidden')
          $quiz.find('.post').removeClass('hidden')

        )

    magnify: ()->
      $quiz = $('#magnify_quiz')
      $quiz.find('.answers a').on({
        click: (ev)->
          ev.preventDefault()
          isCorrect = $(this).hasClass('correct')
          switch isCorrect
            when true then $quiz.find('.correct').removeClass('hidden')
            else $quiz.find('.wrong').removeClass('hidden')

          # hide pre-answered
          $quiz.find('.pre').addClass('hidden')

          # show post-answered
          $quiz.find('.post').removeClass('hidden')
          $quiz.find('.dashed').addClass('no-margin-top')

      })

    listen: ()->
      $quiz = $('#listen_quiz')
      $quiz.find('.answers a').on({
        click: (ev)->
          ev.preventDefault()
          isCorrect = $(this).hasClass('correct')
          switch isCorrect
            when true then $quiz.find('.correct').removeClass('hidden')
            else $quiz.find('.wrong').removeClass('hidden')

          # hide pre-answered
          $quiz.find('.pre').addClass('hidden')

          # show post-answered
          $quiz.find('.post').removeClass('hidden')
          $quiz.find('.dashed').addClass('no-margin-top')

      })

    genetic: ($quiz)->
      $quiz.find('.answers a').on({
        click: (ev)->
          ev.preventDefault()
          isCorrect = $(this).hasClass('correct')
          if isCorrect
            $quiz.find('.correct').removeClass('hidden')
            $quiz.find('.wrong').addClass('hidden')

            # hide pre-answered
            $quiz.find('.pre').addClass('hidden')

            # show post-answered
            $quiz.find('.post').removeClass('hidden')

            # adjust margins
            $quiz.find('.no-margin-bottom').removeClass('no-margin-bottom')
            $quiz.find('.modal-body').addClass('no-margin-bottom')

          else
            # show wrong help text
            $quiz.find('.wrong').removeClass('hidden')
            $quiz.find('.modal-header .pre').addClass('hidden')

        })



  modals:

    open: (section)->
      openModal = null
      switch section
        when "#measurements" then openModal = "#measurements_quiz"
        when "#magnify" then openModal = "#magnify_quiz"
        when "#listen" then openModal = "#listen_quiz"
        when "#genetic" then openModal = "#genetic_quiz"
        when "#lice-section" then openModal = "#lice_quiz"
        when "#range" then openModal = "#step_4"

      if openModal != null
        $(openModal).modal({backdrop: "static"})
        $(openModal).modal('show')
        Router.modals.secondary(openModal)



    secondary: (openModal)->
      nextModal = false
      switch openModal
        when "#magnify_quiz" then nextModal = "#step_1_conclusion"
        when "#genetic_quiz" then nextModal = "#step_2_conclusion"
        when "#lice_quiz" then nextModal = "#step_4_conclusion"
        when "#step_1_conclusion" then nextModal = "#step_2"
        when"#step_2_conclusion" then nextModal = "#step_3"
        # else ()->
        #   Router.route(openModal)
      if nextModal != false

        $(openModal).on("hidden.bs.modal", ()->

          $(nextModal).modal('show')

          Router.modals.secondary(nextModal)

          )

  reset: ()->
    $(".checked").removeClass("checked")
    $(".instructions").removeClass("hidden")
    $(".pre").removeClass('hidden')
    $(".post").addClass('hidden')
    $(".no-margin-top").removeClass("no-margin-top")

}

Listeners = {

  sectionInteractions: (section)->
    howManyIntercations = $(section).find('.icon').length

    if howManyIntercations > 0
      currentInteractions = 0

      $(section).find('.icon').on(
        'click': (ev)->
          ev.preventDefault()
          if $(section).attr('id') != 'magnify'
            $(section).find(".instructions").addClass('hidden')
            $(this).addClass('checked')

          currentInteractions = currentInteractions + 1

          if currentInteractions == howManyIntercations
            # open modal
            if section != '#magnify' && section != "#listen"
              Router.modals.open(section)

            # wait for the last modal to close for magnify / listen
            else

              modalId = $(this).attr('data-target')
              $(modalId).on('hidden.bs.modal', ()->

                Router.modals.open(section)

                )


            # reset interactions
            currentInteractions = 0
            $(section).find('.checked').removeClass('checked')

            # reset measurements list
            if section == "#measurements"
              $(section).find(".hidden").removeClass('hidden')

        )

  measurements: ()->
    # measurements
    $("#measurements .icon").on({
      "click": (ev)->
        ev.preventDefault();
        if !$(this).hasClass('checked')
          $parent = $(this).parent()

          if $(this).hasClass('tail')
            area = "tail"

          else if $(this).hasClass('wing')
            area = "wing"

          else if $(this).hasClass('beak')
            area = "beak"

          $parent.find('.info-' + area ).children('strong').removeClass('hidden')

      })

  router: ()->
    $('.router').on(
      'click': (ev)->
        ev.preventDefault()
        nextSection = $(this).attr('href')
        Router.route(nextSection)
      )

  viewPort: ()->
    $('.viewport .slider').draggable({axis: "x", containment: "parent"})


  magnifier: ()->
    # attach zoom for each bird
    $.each $('.magnify .close'), (i,v)->
      birdId = $(this).attr('data-bird')
      Listeners.attachZoom(birdId)

    # close button
    $('.magnify .close').click( (ev)->
        ev.preventDefault()
        $(this).toggle()

      )

    # listens for zoom
    $('.small span').click( ->
        $(this)
          .parent()
          .parent()
          .find('.close')
          .click()
      )

  attachZoom: (i)->
    $('.bird.' + i + ' img.source')
      .wrap('<span style="display:inline-block"></span>')
      .css('display', 'block')
      .parent()
      .zoom
        url: 'images/bird-' + i + '-large.jpg'
        on: 'click'
        callback: ()->
          console.log i + ' loaded'


}

Router.init()