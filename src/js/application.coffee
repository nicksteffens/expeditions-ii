Router = {

  init: ()->
    console.log 'Router Init'
    # listeners
    Listeners.click()
    Listeners.viewPort()

    #router events
    $('.router').on({
        click: (ev)->
          ev.preventDefault()
          console.log 'router click'

      })

    $('.open-modal').on({
        click: (ev)->
          ev.preventDefault()
          openModal = $(this).attr('href')
          $(openModal).modal('show')
      })


  measurements: {

    quiz: ()->
      $('#measurements_quiz').modal('show')
      $('#measurements_quiz .answers a').on({
        click: (ev)->
          ev.preventDefault()
          if $(this).attr('href') == "correct"
            $('#measurements_quiz .correct').removeClass('hidden')

          else if $(this).attr('href') == "wrong"

            $('#measurements_quiz .wrong').removeClass('hidden')

          # hide pre-answered
          $('#measurements_quiz .pre').addClass('hidden')

          # show post-answered
          $('#measurements_quiz .post').removeClass('hidden')

          $('#measurements_quiz .dashed').addClass('no-margin-top')

        })

  }

  magnify: {

    quiz: (activeModal)->
      # waits for current modal to close
      $(activeModal).on('hidden.bs.modal', ()->
        $('#magnify_quiz').modal('show')
      )

      $('#magnify_quiz .answers a').on({
          click: (ev)->
            ev.preventDefault()
            $parent = $('#magnify_quiz')

            if $(this).attr('href') == "correct"
              $parent.find('.correct').removeClass('hidden')

            else if $(this).attr('href') == "wrong"
              $parent.find('.wrong').removeClass('hidden')

            # hide pre-answered
            $parent.find('.pre').addClass('hidden')


            # show post-answered
            $parent.find('.post').removeClass('hidden')
            $('#measurements_quiz .dashed').addClass('no-margin-top')

        })


  }

  listen: {

    quiz: (activeModal)->
      # wait for active modal to close
      $(activeModal).on('hidden.bs.modal', ()->
        $('#listen_quiz').modal('show')
      )

      $('#listen_quiz .answers a').on({
        click: (ev)->
          ev.preventDefault()
          $parent = $('#listen_quiz')

          if $(this).attr('href') == "correct"
            $parent.find('.correct').removeClass('hidden')

          else if $(this).attr('href') == "wrong"
            $parent.find('.wrong').removeClass('hidden')

          # hide pre-answered
          $parent.find('.pre').addClass('hidden')


          # show post-answered
          $parent.find('.post').removeClass('hidden')
          $('#listen_quiz .dashed').addClass('no-margin-top')

      })

  }

  genetic: {

    quiz: ()->
      $("#genetic_quiz").modal('show')
      $('#genetic_quiz .answers a').on({
          click: (ev)->
            ev.preventDefault()
            $parent = $('#genetic_quiz')

            if $(this).attr('href') == "correct"
              $parent.find('.correct').removeClass('hidden')

            else if $(this).attr('href') == "wrong"
              $parent.find('.wrong').removeClass('hidden')

            # hide pre-answered
            $parent.find('.pre').addClass('hidden')


            # show post-answered
            $parent.find('.post').removeClass('hidden')
            $('#genetic_quiz .dashed').addClass('no-margin-top')

        })

  }

  reset: ()->
    $(".checked").removeClass("checked")
    $(".instructions").removeClass("hidden")
    $(".pre").removeClass('hidden')
    $(".post").addClass('hidden')
    $(".no-margin-top").removeClass("no-margin-top")

}

Listeners = {
  click: ()->

    # measurements
    toMeasure = $("#measurements .icon").length
    measureCount = 0
    $("#measurements .icon").on({
      "click": (ev)->
        ev.preventDefault();
        if !$(this).hasClass('checked')
          $("#measurements .instructions").addClass('hidden')
          $parent = $(this).parent()

          if $(this).hasClass('tail')
            section = "tail"

          else if $(this).hasClass('wing')
            section = "wing"

          else if $(this).hasClass('beak')
            section = "beak"

          $parent.find('.info-' + section ).children('strong').removeClass('hidden')

          $(this).addClass('checked')
          measureCount = measureCount+1

          # activate router
          if measureCount == toMeasure
            Router.measurements.quiz()

      })

    # magnify
    toMagnify = $('#magnify .icon').length
    magnifyCount = 0
    $('#magnify .icon').on({
        click: (ev)->
          ev.preventDefault()
          $('#magnify .instructions').addClass('hidden');

          if !$(this).hasClass('checked')
            $(this).addClass('checked')

            magnifyCount = magnifyCount + 1
            if magnifyCount == toMagnify
              activeModal = $(this).attr('href')
              Router.magnify.quiz(activeModal)


      })

    #listen
    toListen = $("#listen .icon").length
    listenCount = 0
    $('#listen .icon').on({
        click: (ev)->
          ev.preventDefault()
          $('#listen .instructions').addClass('hidden')

          if !$(this).hasClass('checked')
            $(this).addClass('checked');

            listenCount = listenCount + 1
            if listenCount == toListen
              activeModal = $(this).attr('href')
              Router.listen.quiz(activeModal)
      })


    # genetic
    toGenetic = $("#genetic .icon").length
    geneticCount = 0
    $('#genetic .icon').on({
        click: (ev)->
          ev.preventDefault()
          $('#genetic .instructions').addClass('hidden')

          if !$(this).hasClass('checked')
            $(this).addClass('checked');

            geneticCount = geneticCount + 1
            if geneticCount == toGenetic
              Router.genetic.quiz()
      })


  viewPort: ()->
    $('.dna').on('shown.bs.modal', ()->
      $('.viewport .slider').draggable({axis: "x", containment: ".viewport"})
      )

}

Router.init()