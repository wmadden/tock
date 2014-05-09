Polymer "tock-task-list",
  ready: ->

  task_onClick: (event, detail, sender) ->
    return unless @canSelect
    task = sender.templateInstance.model.task
    @fire('select', { task: task })
