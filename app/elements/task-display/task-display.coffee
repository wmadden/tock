BREAK_LENGTH = 5 * 60 * 1000
Polymer "tock-task-display",
  ready: ->

  stopPomodoro: ->
    @task.stopPomodoro()

  startNewPomodoro: ->
    @task.startPomodoro()

  stopTask: (event) ->
    event.preventDefault()
    @fire('stop', { task: @task })

  finishTask: (event) ->
    event.preventDefault()
    @fire('finished', { task: @task })