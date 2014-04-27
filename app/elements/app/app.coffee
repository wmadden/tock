NEW_TASK_VIEW = 'newTask'
TASK_DISPLAY_VIEW = 'taskDisplay'

Polymer "tock-app",
  ready: ->
    @pastTasks = []
    @makeNewTask()

  makeNewTask: ->
    @selectedView = NEW_TASK_VIEW
    @pastTasks.push @currentTask if @currentTask
    @currentTask = null

  startTask: (task) ->
    @currentTask = task
    task.startPomodoro()
    @selectedView = TASK_DISPLAY_VIEW

  finishTask: (task) ->
    @pastTasks.push task
    @currentTask = null
    @selectedView = NEW_TASK_VIEW

  # -- Event listeners --

  newTask_onCreate: (event, detail) ->
    @startTask(detail.task)

  currentTask_onFinish: (event, detail) ->
    @finishTask(detail.task)
