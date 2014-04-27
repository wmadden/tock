Polymer "tock-app",
  ready: ->
    @resetTimer()

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

  stopTimer: ->
    clearInterval @timerInterval
    @timerInterval = null
    @timerState = 'stopped'

  toggleTimer: ->
    if @timerState == 'started'
      @stopTimer()
    else
      @startTimer()

  resetTimer: ->
    @stopTimer()
    @time = 0