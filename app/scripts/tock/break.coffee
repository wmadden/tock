tock = window.tock ?= {}

BREAK_LENGTH_IN_MS = 5 * 60 * 1000

class tock.Break
  @BREAK_START: 'break-start'
  @BREAK_STOP: 'break-stop'
  @BREAK_COMPLETE: 'break-complete'

  constructor: ->
    @timeRemaining = BREAK_LENGTH_IN_MS
    @emitter = new EventEmitter2()

  start: ->
    @startTimer()
    @emitter.emit(Break.BREAK_START)

  stop: ->
    @stopTimer()
    @emitter.emit(Break.BREAK_STOP)

  # -- Timer gunk

  startTimer: ->
    @startedAt = Date.now()
    @timerState = 'started'
    @timerID = setInterval( =>
      timeElapsed = Date.now() - @startedAt
      @timeRemaining = BREAK_LENGTH_IN_MS - timeElapsed
      @timeRemaining = 0 if @timeRemaining < 0

      if @timeRemaining == 0
        @emitter.emit(Break.BREAK_COMPLETE)
        @stop()

      Platform.flush()
    , 100)

  stopTimer: ->
    clearInterval @timerID
    @timerID = null