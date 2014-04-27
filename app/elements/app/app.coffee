NEW_TASK_VIEW = 'newTask'
TASK_DISPLAY_VIEW = 'taskDisplay'

Polymer "tock-app",
  ready: ->
    @pastTasks = @loadPastTasks()# [{ description: 'hello'}]
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
    @pastTasks.unshift task
    @currentTask = null
    @selectedView = NEW_TASK_VIEW
    @save()

  # -- Persistence

  loadPastTasks: ->
    json = JSON.parse(localStorage.getItem('tasks'))
    return [] unless json
    _(json).map (element) -> tock.Task.from(element)

  save: ->
    localStorage.setItem('tasks', JSON.stringify(@pastTasks))

  # -- Event listeners --

  newTask_onCreate: (event, detail) ->
    @startTask(detail.task)

  taskDisplay_finished: (event, detail) ->
    @finishTask(detail.task)
