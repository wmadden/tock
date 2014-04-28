Polymer "tock-task-display",
  ready: ->

  taskChanged: (oldValue, newValue) ->
    oldValue.emitter.removeAllListeners('completed') if oldValue
    newValue.emitter.on('completed', => @playAlarm()) if newValue

  stopPomodoro: ->
    @task.stopPomodoro()

  startNewPomodoro: ->
    @task.startPomodoro()

  finishTask:  ->
    @fire('finished', { task: @task })

  playAlarm: ->
    @$.alarm.play()