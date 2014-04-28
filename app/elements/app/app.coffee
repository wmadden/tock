NEW_TASK_VIEW = 'newTask'
TASK_DISPLAY_VIEW = 'taskDisplay'

Polymer "tock-app",
  ready: ->
    @tasks = @loadTasks()# [{ description: 'hello'}]
    @makeNewTask()

  makeNewTask: ->
    @selectedView = NEW_TASK_VIEW
    @tasks.push @currentTask if @currentTask
    @currentTask = null

  startTask: (task) ->
    @currentTask = task
    task.startPomodoro()
    @selectedView = TASK_DISPLAY_VIEW

  finishTask: (task) ->
    @tasks.unshift task
    @currentTask = null
    @selectedView = NEW_TASK_VIEW
    @save()

  # -- Persistence

  loadTasks: ->
    json = JSON.parse(localStorage.getItem('tasks'))
    return [] unless json
    _(json).map (element) -> tock.Task.from(element)

  save: ->
    localStorage.setItem('tasks', JSON.stringify(@tasks))

  # -- Event listeners --

  newTask_onCreate: (event, detail) ->
    @startTask(detail.task)

  taskDisplay_finished: (event, detail) ->
    @finishTask(detail.task)
