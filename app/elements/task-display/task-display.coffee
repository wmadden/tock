BREAK_LENGTH = 5 * 60 * 1000
RUNNING_CLASS = 'running'
STOPPED_CLASS = 'stopped'

Polymer "tock-task-display",
  ready: ->

  running: false

  stopPomodoro: ->
    @task.stopPomodoro()
    this.running = false

  startNewPomodoro: ->
    @task.startPomodoro()
    this.running = true

  stopTask: (event) ->
    @task.stopPomodoro()
    event.preventDefault()
    this.running = false
    @fire('stop', { task: @task })

  finishTask: (event) ->
    event.preventDefault()
    this.running = false
    @stopPomodoro()
    @fire('finished', { task: @task })
