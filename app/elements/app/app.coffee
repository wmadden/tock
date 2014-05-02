NEW_TASK_VIEW = 'newTask'
TASK_DISPLAY_VIEW = 'taskDisplay'
BREAK_DISPLAY_VIEW = 'breakDisplay'

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

  finishTask: ->
    @tasks.unshift @currentTask
    @currentTask = null
    @show NEW_TASK_VIEW
    @save()

  startBreak: ->
    @currentBreak = new tock.Break()

    @currentBreak.emitter.on(tock.Break.BREAK_COMPLETE, => @break_finish())

    @currentBreak.start()
    @show BREAK_DISPLAY_VIEW

  abortBreak: ->
    @currentBreak.emitter.removeAllListeners(tock.Break.BREAK_COMPLETE)
    @endBreak()

  endBreak: ->
    @currentBreak = null
    @show TASK_DISPLAY_VIEW

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
    @finishTask()

  breakDisplay_abortBreak: (event, detail) ->
    @abortBreak()

  # -- Model event listeners

  task_pomodoroComplete: ->
    @currentTask.emitter.removeAllListeners(tock.Task.POMODORO_COMPLETE)

    options = {
      type: 'basic',
      iconUrl: '/images/icon-128.png',
      title: "Pomodoro #{@currentTask.totalPomodoros}/#{@currentTask.estimatedPomodoros} finished!",
      message: 'Nice work, take a 5 minute break :)',
    }
    chrome.notifications.create('pomodoro-complete' + Date.now(), options, ->)

    @playAlarm()
    @startBreak()

  break_finish: ->
    @currentBreak.emitter.removeAllListeners(tock.Break.BREAK_COMPLETE)

    options = {
      type: 'basic',
      iconUrl: '/images/icon-128.png',
      title: "Break over",
      message: 'Ok, back to work.',
    }
    chrome.notifications.create('break-complete' + Date.now(), options, ->)
    @playAlarm()

    @endBreak()



