Polymer "tock-new-task",
  ready: ->

  startTask: (event, detail, sender) ->
    event.preventDefault()
    @fire('start', { task: @newTask() })
    @reset()

  newTask: ->
    new tock.Task( @$.descriptionInput.value, @$.estimateInput.value )

  reset: ->
    @$.descriptionInput.value = null
    @$.estimateInput.value = null
