Router = {
  init: ()->
    # listeners
    Listeners.measurements('#measurements')
    Listeners.genetic('#genetic')
    Listeners.genetic('#lice-section')
    Listeners.viewPort()
    Listeners.router()
    Listeners.magnifier()
    Listeners.listen('#listen')

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
    # console.log 'Incoming Section ', section
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
          soundManager.stopAll()
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
        when "#magnify_quiz" then openModal = "#magnify_quiz"
        when "#listen" then openModal = "#listen_quiz"
        when "#genetic" then openModal = "#genetic_quiz"
        when "#lice-section" then openModal = "#lice_quiz"
        when "#range" then openModal = "#step_4"

      if openModal != null
        console.log 'next modal %o', openModal if window.console
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
    howManyIntercations = $(section).find('.icon:not(.close)').length

    if howManyIntercations > 0
      currentInteractions = 0

      $(section).find('.icon').on(
        'click': (ev)->
          ev.preventDefault()
          if $(section).attr('id') != 'magnify'
            $(section).find(".instructions").addClass('hidden')

            if section isnt '#measurements'
              if section isnt '#genetic'
                if section isnt '#lice-section'
                  $(this).addClass('checked')

          currentInteractions = currentInteractions + 1

          if currentInteractions == howManyIntercations
            # open modal
            if section isnt "#listen"
              if section isnt "#genetic"
                if section isnt "#measurements"
                  if section isnt "#lice-section"
                    Router.modals.open(section)

            # wait for the last modal to close for magnify / listen
            else if section is '#listen'
              modalId = $(this).attr('data-target')
              $(modalId).on('hidden.bs.modal', ()->
                Router.modals.open(section)

                )


            # reset interactions
            currentInteractions = 0
            if section isnt "#measurements"
              if section isnt '#genetic'
                if section isnt '#lice-section'
                  Listeners.resetSection(section)




        )

  resetSection: (section)->
    # uncheck checked
    $(section)
      .find('.checked')
      .removeClass('checked')

    # show hidden
    $(section)
      .find(".hidden")
      .removeClass('hidden')

    # reset animations
    $(section)
      .find('.complete')
      .removeClass('complete')

    # hide sequence
    $(section)
      .find('.genetic-sequence')
      .addClass('hidden')

    # audio section
    if section == "#listen"
      # player
      $(section)
        .find('.ui360')
        .addClass('hidden')
      # sonogram
      $(section)
        .find('.sonogram')
        .addClass('hidden')
      # instructions
      $(section)
        .find('.instructions h3')
        .removeClass('hidden')
      # continue btn
      $(section)
        .find('.instructions .btn')
        .addClass('hidden')





  measurements: (section)->
    requireAnimations = $(section).find('.icon:not(.close)').length
    # measurements
    $(section).find('.icon').on({
      "click": (ev)->
        $self = $(this)
        $parent = $(this).parent()
        ev.preventDefault();
        if !$(this).hasClass('checked')
          $self.addClass('animate')

          if $(this).hasClass('tail')
            area = "tail"

          else if $(this).hasClass('wing')
            area = "wing"

          else if $(this).hasClass('beak')
            area = "beak"

          # end of animation
          $self.one('webkitAnimationEnd oanimationend msAnimationEnd animationend ', (e)->

              $self
                .removeClass('animate')
                .addClass('complete')

              setTimeout( (e)->
                # show info
                $parent
                  .find('.info-' + area )
                  .children('strong')
                  .removeClass('hidden')

                # complete checkmark
                $self
                  .removeClass('complete')
                  .addClass('checked')

                # reset Section after all animations have completed
                if $(section).find('.icon.checked').length  == requireAnimations
                  Listeners.resetSection(section)
                  Router.modals.open(section)

              , 300)
          )

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
          .toggle()
      )

    # quiz route
    $('#magnify .instructions .btn').click ()->
      # console.log 'magnify router'
      Router.modals.open($(this).attr('href'))


  attachZoom: (i)->
    $('.bird.' + i + ' img.source')
      .wrap('<span style="display:inline-block"></span>')
      .css('display', 'block')
      .parent()
      .zoom
        url: 'images/bird-' + i + '-large.jpg'
        on: 'click'
        callback: ()->
          if window.console
            console.log 'image loaded'


  genetic: (section)->

    requireAnimations = $(section).find('.icon:not(.close)').length
    $(section).find( ".icon.helix" ).draggable(
      containment: "parent"
      revert: true
      start: (e, ui)->
        $(this).trigger('click')
      )
    $(section).find( ".genetic-analysis" ).droppable(
      accept: ".icon.helix"

      drop: (e, ui)->
        ui.draggable.addClass('hidden')
        $self = $(this)
        $self.addClass('animate')

        $self.one('webkitAnimationEnd oanimationend msAnimationEnd animationend ', (e)->
          # show complete
          $self
            .removeClass('animate')
            .addClass('complete')

          # show sequence
          $self.siblings('.genetic-sequence')
            .removeClass('hidden')

          # show checked
          ui.draggable
            .addClass('checked')
            .removeClass('hidden')

          # resetSection
          setTimeout( (e)->
            # reset Section after all animations have completed
            if $(section).find('.icon.checked').length  == requireAnimations
              console.log 'required animations' if window.console
              Listeners.resetSection(section)
              Router.modals.open(section)

          , 300)


          )

      )

  listen: (section)->
    # audio player stuff
    soundManager.setup({
      # // path to directory containing SM2 SWF
      url: 'swf/'
    })
    # play count
    playCount = 0

    $(section).find('.draggable').draggable(
      revert: true
      )
    $(section).find('.dropzone').droppable(
      accept: '.draggable'
      drop: (e, ui)->
        player = $(this).find('.ui360')
        bird = $(this).parent('.bird')

        player.toggleClass('hidden') if player.hasClass('hidden')
        bird.find('.sonogram').toggleClass('hidden') if bird.find('.sonogram').hasClass('hidden')
        player.find('.sm2-360btn').click()
        playCount = playCount + 1

        if playCount == $(section).find('.dropzone').length
          $(section).find('.instructions h3').addClass('hidden')
          $(section).find('.instructions .btn').removeClass('hidden')

          # quiz route
          $(section).find('.instructions .btn').click ()->
            #stop all sound
            soundManager.stopAll()

            # reset section
            Listeners.resetSection(section)
            playCount = 0
            # openModal
            Router.modals.open(section)


      )




}

Router.init()