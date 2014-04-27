Polymer "tock-new-task",
  ready: ->

  startTask: (event, detail, sender) ->
    event.preventDefault()
    @fire('start', { task: @newTask() })

  newTask: ->
    new tock.Task( @.$.descriptionInput.value, @.$.estimateInput.value )
