Polymer "tock-app",
  ready: ->
    @time = 0
    @timerState = 'stopped'

  attached: ->

  detached: ->
    clearInterval @timerInterval if @timerInterval

  startTimer: ->
    @lastTick = Date.now()
    @timerState = 'started'
    @timerInterval = setInterval( =>
      @time += Date.now() - @lastTick
      @lastTick = Date.now()
    , 100)

  pauseTimer: ->
    clearInterval @timerInterval
    @timerInterval = null
    @timerState = 'stopped'

  toggleTimer: ->
    if @timerState == 'started'
      @pauseTimer()
    else
      @startTimer()