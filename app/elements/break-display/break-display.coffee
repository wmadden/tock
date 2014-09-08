ABORT_BREAK_EVENT = 'abort-break'

Polymer "tock-break-display",
  stopBreak: ->
    @break.stop()
    @fire(ABORT_BREAK_EVENT)

  finishTask: ->
    @fire('finished')
