NEW_TASK_VIEW = 'newTask'
TASK_DISPLAY_VIEW = 'taskDisplay'

Polymer "tock-app",
  ready: ->
    @loadTasks()# [{ description: 'hello'}]
    @makeNewTask()

  # -- UI

  show: (view) ->
    @selectedView = view

  # -- Business logic

  makeNewTask: ->
    @show NEW_TASK_VIEW
    @tasks.push @currentTask if @currentTask
    @currentTask = null

  startTask: (task) ->
    task.emitter.on(tock.Task.POMODORO_COMPLETE, => @task_pomodoroComplete()) if task

    @currentTask = task
    task.startPomodoro()
    @show TASK_DISPLAY_VIEW

  finishTask: (task) ->
    @tasks.unshift task
    @currentTask = null
    @show NEW_TASK_VIEW
    @save()

  # -- Audio

  playAlarm: ->
    @$.alarm.play()

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

  # -- UI Event listeners --

  newTask_onCreate: (event, detail) ->
    @startTask(detail.task)

  taskDisplay_finished: (event, detail) ->
    @finishTask(detail.task)

  # -- Model event listeners

  task_pomodoroComplete: ->
    @currentTask.emitter.removeAllListeners(tock.Task.POMODORO_COMPLETE)

    options = {
      type: 'basic',
      iconUrl: '/images/icon-128.png',
      title: "Pomodoro #{@currentTask.totalPomodoros}/#{@currentTask.estimatedPomodoros} finished!",
      message: 'Nice work, take a 5 minute break :)',
    }
    chrome.notifications.create('pomodoro-complete', options, ->)

    @playAlarm()
