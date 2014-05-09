Polymer "tock-new-task",
  ready: ->

  startTask: ->
    console.log('start')
    @fire('start', { task: @newTask() })
    @reset()

  planTask: ->
    console.log('plan')
    @fire('plan', { task: @newTask() })
    @reset()

  onKeypress: (event, detail, sender) ->
    if event.keyCode == 13
      event.preventDefault()
      event.stopImmediatePropagation()

      if event.shiftKey
        @planTask()
      else
        @startTask()

  start_onClick: (event) ->
    event.preventDefault()
    @startTask()

  plan_onClick: (event) ->
    event.preventDefault()
    @planTask()

  newTask: ->
    new tock.Task( @$.descriptionInput.value, @$.estimateInput.value )

  reset: ->
    @$.descriptionInput.value = null
    @$.estimateInput.value = null
