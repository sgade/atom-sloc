SlocView = require './sloc-view'

module.exports =
  activate: ->
    
    createView = =>
      @slocView = new SlocView()
      atom.workspaceView.statusBar?.appendLeft @slocView
    
    if atom.workspaceView.statusBar
      createView()
    else
      atom.packages.once 'activated', ->
        createView()

  deactivate: ->
    @slocView?.destroy()
