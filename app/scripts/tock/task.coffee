tock = window.tock ?= {}

POMODORO_TIME_IN_MS = 5000 #25 * 60 * 1000

class tock.Task
  constructor: (@description, estimatedPomodoros, @pomodorosCompleted = 0) ->
    @resetTimer()
    @estimatedPomodoros = parseInt(estimatedPomodoros) || 1
    @totalPomodoros = @pomodorosCompleted
    @emitter = new EventEmitter2()

  @from: (object) ->
    result = new tock.Task(object.description, object.estimatedPomodoros, object.pomodorosCompleted)

  startPomodoro: ->
    @startTimer()
    @pomodoroStarted = true
    @updateTotalPomodoros()
    @emitter.emit('start')

  stopPomodoro: ->
    @pomodoroStarted = false
    @updateTotalPomodoros()
    @resetTimer()
    @emitter.emit('stop')

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
        @emitter.emit('completed')
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

