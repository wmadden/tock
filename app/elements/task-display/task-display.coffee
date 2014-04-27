Polymer "tock-task-display",
  ready: ->

  stopPomodoro: ->
    @task.stopPomodoro()

  startNewPomodoro: ->
    @task.startPomodoro()

  finishTask:  ->
    @fire('finished', { task: @task })