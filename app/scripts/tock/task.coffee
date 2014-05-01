tock = window.tock ?= {}

POMODORO_TIME_IN_MS = 5000 #25 * 60 * 1000

class tock.Task
  @POMODORO_COMPLETE: 'pomodoro-complete'
  @POMODORO_START: 'pomodoro-start'
  @POMODORO_STOP: 'pomodoro-stop'

  constructor: (@description, estimatedPomodoros, @pomodorosCompleted = 0) ->
    @resetTimer()
    @estimatedPomodoros = parseInt(estimatedPomodoros) || 1
    @totalPomodoros = @pomodorosCompleted
    @emitter = new EventEmitter2()

  @from: (object) ->
    result = new Task(object.description, object.estimatedPomodoros, object.pomodorosCompleted)

  startPomodoro: ->
    @startTimer()
    @pomodoroStarted = true
    @updateTotalPomodoros()
    @emitter.emit(Task.POMODORO_START)

  stopPomodoro: ->
    @pomodoroStarted = false
    @updateTotalPomodoros()
    @resetTimer()
    @emitter.emit(Task.POMODORO_STOP)

  updateTotalPomodoros: ->
    @totalPomodoros = @pomodorosCompleted
#    @totalPomodoros += 1 if @pomodoroStarted

  # -- Timer gunk

  startTimer: ->
    @lastTick = Date.now()
    @timerState = 'started'
    @timerInterval = setInterval( =>
      @timeElapsed += Date.now() - @lastTick
      @timeRemaining = POMODORO_TIME_IN_MS - @timeElapsed
      @timeRemaining = 0 if @timeRemaining < 0
      @lastTick = Date.now()

      if @timeRemaining == 0
        @pomodorosCompleted += 1
        @emitter.emit(Task.POMODORO_COMPLETE)
        @stopPomodoro()

      Platform.flush()
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
    @timeElapsed = 0
    @timeRemaining = POMODORO_TIME_IN_MS

