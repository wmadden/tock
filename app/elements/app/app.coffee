NEW_TASK_VIEW = 'newTask'
TASK_DISPLAY_VIEW = 'taskDisplay'

Polymer "tock-app",
  ready: ->
    @loadTasks()# [{ description: 'hello'}]
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
    @storageGet({ tasks: [] }, (value) =>
      console.log value
      @tasks = _(value.tasks).map (element) -> tock.Task.from(element)
    )

  save: ->
    @storageSet('tasks', @tasks)

  storageGet: (key, callback) ->
    if chrome
      chrome.storage.sync.get(key, callback)
    else
      result = JSON.parse localStorage.getItem(key)
      callback(result)

  storageSet: (key, value) ->
    if chrome
      obj = {}
      obj[key] = value
      chrome.storage.sync.set(obj)
    else
      localStorage.set key, JSON.stringify(value)

  # -- Event listeners --

  newTask_onCreate: (event, detail) ->
    @startTask(detail.task)

  taskDisplay_finished: (event, detail) ->
    @finishTask(detail.task)
