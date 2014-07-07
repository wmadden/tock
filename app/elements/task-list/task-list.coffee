Polymer "tock-task-list",
  ready: ->

  task_onClick: (event, detail, sender) ->
    return unless @canSelect
    task = sender.templateInstance.model.task
    @fire('select', { task: task })

  trash_onClick: (event, detail, sender) ->
    event.preventDefault()
    event.stopImmediatePropagation()
    task = sender.templateInstance.model.task
    @fire('trash', { task: task })

  canTrash: (task) -> true
