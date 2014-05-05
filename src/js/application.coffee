Router = {
  init: ()->
    # listeners
    Listeners.measurements('#measurements')
    Listeners.genetic('#genetic')
    Listeners.genetic('#lice-section')
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
        console.log openModal
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
          if console.log
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
              console.log 'required animations'
              Listeners.resetSection(section)
              Router.modals.open(section)

          , 300)


          )






      )

  listen: (section)->
    # NOTES:
    #   1. Get MP3's playing via default player
    #   2. Style Player

    $(section).find('.draggable').draggable(
      revert: true
      )
    $(section).find('.dropzone').droppable(
      accept: '.draggable'
      drop: (e, ui)->
        player = $(this)
        sonogramURL = $(this).attr('data-href')
        Listeners.playSonogram(player, sonogramURL)
      )

  playSonogram: (player, URL)->
    $parent = player.parent()
    playerID = $(player).attr('data-target')
    template = Listeners.sonogramTemplate(playerID.slice(1))

    # attach template
    $parent.append(template)

    $(playerID).jPlayer
      swfPath: "../js"
      solution: "html, flash"
      supplied: "mp3"
      preload: "metadata"
      volume: 0.8
      muted: false
      backgroundColor: "#000000"
      cssSelectorAncestor: playerID
      cssSelector:
        videoPlay: ".jp-video-play"
        play: ".cp-play"
        pause: ".cp-pause"
        stop: ".jp-stop"
        seekBar: ".jp-seek-bar"
        playBar: ".jp-play-bar"
        mute: ".jp-mute"
        unmute: ".jp-unmute"
        volumeBar: ".jp-volume-bar"
        volumeBarValue: ".jp-volume-bar-value"
        volumeMax: ".jp-volume-max"
        playbackRateBar: ".jp-playback-rate-bar"
        playbackRateBarValue: ".jp-playback-rate-bar-value"
        currentTime: ".jp-current-time"
        duration: ".jp-duration"
        title: ".jp-title"
        fullScreen: ".jp-full-screen"
        restoreScreen: ".jp-restore-screen"
        repeat: ".jp-repeat"
        repeatOff: ".jp-repeat-off"
        gui: ".jp-gui"
        noSolution: ".jp-no-solution"

      errorAlerts: false
      warningAlerts: false




  sonogramTemplate: (id)->
    '<div id="' + id + '" class="cp-container"><div class="cp-buffer-holder" style="display: block;"> <!-- .cp-gt50 only needed when buffer is > than 50% -->  <div class="cp-buffer-1"></div>  <div class="cp-buffer-2"></div></div><div class="cp-progress-holder" style="display: block;"> <!-- .cp-gt50 only needed when progress is > than 50% -->  <div class="cp-progress-1" style="-webkit-transform: rotate(0deg);"></div>  <div class="cp-progress-2" style="-webkit-transform: rotate(0deg); display: none;"></div></div><div class="cp-circle-control"></div><ul class="cp-controls">  <li><a class="cp-play" tabindex="1">play</a></li>  <li><a class="cp-pause" style="display: none;" tabindex="1">pause</a></li> <!-- Needs the inline style here, or jQuery.show() uses display:inline instead of display:block --></ul></div>'


}

Router.init()