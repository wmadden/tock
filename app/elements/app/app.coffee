Polymer "tock-app",
  ready: ->
    @time = 0

  attached: ->
    @timerInterval = setInterval( =>
      @time += 1
    , 1000)

  detached: ->
    clearInterval @timerInterval
