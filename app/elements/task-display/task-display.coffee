BREAK_LENGTH = 5 * 60 * 1000
Polymer "tock-task-display",
  ready: ->

  stopPomodoro: ->
    @task.stopPomodoro()

  startNewPomodoro: ->
    @task.startPomodoro()

  finishTask:  ->
    @fire('finished', { task: @task })