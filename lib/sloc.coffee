SlocView = require './sloc-view'

module.exports =
  slocView: null

  activate: (state) ->
    @slocView = new SlocView(state.slocViewState)

  deactivate: ->
    @slocView.destroy()

  serialize: ->
    slocViewState: @slocView.serialize()
