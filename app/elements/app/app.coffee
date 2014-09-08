PLAN_VIEW = 'planView'
TASK_VIEW = 'taskView'
BREAK_VIEW = 'breakView'

chromeStorageAvailable = -> chrome?.storage?

Polymer "tock-app",
  ready: ->
    @loadTasks()# [{ description: 'hello'}]
    @show PLAN_VIEW

  # -- UI

  show: (view) ->
    @selectedView = view

  updateCalculatedProperties: ->
    @unfinishedTasks = _(@tasks).filter (task) => task.state != 'finished' && !task.archived
    @finishedTasks = _(@tasks).filter (task) -> task.state == 'finished' && !task.archived
    @save()

  # -- Business logic

  planTask: (task) -> @registerTask(task)

  selectTask: (task) ->
    return if @currentTask?.pomodoroStarted
    @currentTask = task
    if @currentTask
      task.emitter.on(tock.Task.POMODORO_COMPLETE, => @task_pomodoroComplete()) if task
      @show TASK_VIEW
    else
      @currentTask.emitter.removeAllListeners(tock.Task.POMODORO_COMPLETE)
      @show PLAN_VIEW
    @updateCalculatedProperties()

  deselectTask: -> @selectTask(null)

  startTask: (task) ->
    task.startPomodoro()
    @selectTask(task)

  finishTask: ->
    @currentTask.state = tock.Task.FINISHED
    @deselectTask()
    @save()
    @startBreak()

  startBreak: ->
    @currentBreak = new tock.Break()

    @currentBreak.emitter.on(tock.Break.BREAK_COMPLETE, => @break_finish())

    @currentBreak.start()
    @show BREAK_VIEW

  abortBreak: ->
    @currentBreak.emitter.removeAllListeners(tock.Break.BREAK_COMPLETE)
    @endBreak()

  endBreak: ->
    @currentBreak = null
    @show TASK_VIEW

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
        tasks = _(value).compact()
        @tasks = _(tasks).map (element) -> tock.Task.from(element)
      catch e
        console.log 'error while processing:', e
      console.log "tasks processed:", @tasks

      @updateCalculatedProperties()
      @save()
    )

  save: ->
    @storageSet('tasks', @tasks)

  storageGet: (key, defaultValue, callback) ->
    if chromeStorageAvailable()
      query = {}
      query[key] = defaultValue
      chrome.storage.local.get(query, (result) ->
        callback(result[key])
      )
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

  breakDisplay_finishTask: (event, detail) ->
    @finishTask()

  unfinishedTaskList_onSelectTask: (event, detail, sender) ->
    task = detail.task
    console.log('select task = ', task)
    @selectTask(task)

  taskList_onTrash: (event, detail, sender) ->
    task = detail.task
    console.log('trash task = ', task)
    @trashTask(task)

  # -- Model event listeners

  task_pomodoroComplete: ->
    console.log('pomodoro complete')

    options = {
      type: 'basic',
      iconUrl: '/images/icon-128.png',
      title: "Pomodoro #{@currentTask.totalPomodoros}/#{@currentTask.estimatedPomodoros} finished!",
      message: 'Nice work, take a 5 minute break :)',
    }
    chrome?.notifications?.create('pomodoro-complete' + Date.now(), options, ->)

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
