{View} = require 'atom'

module.exports =
class SlocView extends View
  @content: ->
    @div class: 'sloc overlay from-top', =>
      @div "The Sloc package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "sloc:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "SlocView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
