{View} = require 'atom'
sloc = require 'sloc'

module.exports =
class SlocView extends View
  @content: ->
    @div class: 'sloc inline-block', =>
      @span class: 'all', outlet: 'allSloc'

  initialize: ->
    statusBar = atom.workspaceView.statusBar
    atom.workspaceView.command "sloc:update", => @update()
    @subscribe statusBar, 'active-buffer-changed', => @update()
    statusBar.subscribeToBuffer 'saved modified-status-changed', => @update()
    
  # Update after load
  afterAttach: ->
    @update()

  # Tear down any state and detach
  destroy: ->
    @unsubscribe()
    @detach()

  update: ->
    @status = @getSlocInfo()
    @allSloc.text "Loc: " + @status?.loc + "\tSloc: " + @status?.sloc + "\tCLoc: " + @status?.cloc
      
  getSlocInfo: ->
    editor = @getCurrentEditor()
    
    content = editor.editor.buffer.lines.join('\n');
    language = "coffeescript"
    
    stats = sloc content, language
    
    stats
    
  getCurrentEditor: ->
    editorArray = atom.workspaceView.getEditorViews().filter( (editor) ->
      editor.active
    )
    editorArray[0]
    
