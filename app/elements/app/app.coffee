NEW_TASK_VIEW = 'newTask'
TASK_DISPLAY_VIEW = 'taskDisplay'
BREAK_DISPLAY_VIEW = 'breakDisplay'

chromeStorageAvailable = -> chrome?.storage?

Polymer "tock-app",
  ready: ->
    @loadTasks()# [{ description: 'hello'}]
    @show NEW_TASK_VIEW

  # -- UI

  show: (view) ->
    @selectedView = view

  updateCalculatedProperties: ->
    @unfinishedTasks = _(@tasks).filter (task) => task.state != 'finished' && task != @currentTask
    @finishedTasks = _(@tasks).filter (task) -> task.state == 'finished' && !task.archived
    @save()

  # -- Business logic

  planTask: (task) -> @registerTask(task)

  selectTask: (task) ->
    return if @currentTask?.pomodoroStarted
    @currentTask = task
    if @currentTask
      @show TASK_DISPLAY_VIEW
    else
      @show NEW_TASK_VIEW
    @updateCalculatedProperties()

  deselectTask: -> @selectTask(null)

  startTask: (task) ->
    task.emitter.on(tock.Task.POMODORO_COMPLETE, => @task_pomodoroComplete()) if task
    task.startPomodoro()
    @selectTask(task)

  finishTask: ->
    @currentTask.state = tock.Task.FINISHED
    @deselectTask()
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

  registerTask: (task) ->
    @tasks.push task
    @updateCalculatedProperties()

  trashTask: (task) ->
    task.archived = true
    @updateCalculatedProperties()

  # -- Audio

  playAlarm: ->
    @$.alarm.play()

  # -- Persistence

  loadTasks: ->
    @storageGet('tasks', [], (value) =>
      console.log "tasks loaded:", value
      try
        tasks = _(value.tasks).compact()
        @tasks = _(tasks).map (element) -> tock.Task.from(element)
      catch e
        console.log 'error while processing:', e
      console.log "tasks processed:", @tasks
      @updateCalculatedProperties()
    )

  save: ->
    @storageSet('tasks', @tasks)

  storageGet: (key, defaultValue, callback) ->
    if chromeStorageAvailable()
      query = {}
      query[key] = defaultValue
      chrome.storage.local.get(query, callback)
    else
      result = localStorage.getItem(key)
      
      if result
        try
          result = JSON.parse(result)
        catch
          result = defaultValue
      else
        result = defaultValue

      callback(result)

  storageSet: (key, value) ->
    if chromeStorageAvailable()
      obj = {}
      obj[key] = value
      console.log("chrome.storage.local.set(", obj, ')')
      chrome.storage.local.set(obj, ->
        console.log 'local callback, runtime.lastError =', chrome.runtime.lastError if chrome.runtime.lastError
      )
    else
      localStorage.setItem key, JSON.stringify(value)

  # -- UI Event listeners --

  newTask_onStart: (event, detail) ->
    @registerTask(detail.task)
    @startTask(detail.task)

  newTask_onPlan: (event, detail) ->
    @planTask(detail.task)

  taskDisplay_stop: (event, detail) ->
    @deselectTask()

  taskDisplay_finished: (event, detail) ->
    @finishTask()

  breakDisplay_abortBreak: (event, detail) ->
    @abortBreak()

  unfinishedTaskList_onSelectTask: (event, detail, sender) ->
    task = detail.task
    console.log('select task = ', task)
    @selectTask(task)

  finishedTaskList_onTrash: (event, detail, sender) ->
    task = detail.task
    console.log('trash task = ', task)
    @trashTask(task)

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
