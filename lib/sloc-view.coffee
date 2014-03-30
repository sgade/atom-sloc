{View} = require 'atom'
sloc = require 'sloc'

module.exports =
class SlocView extends View
  @content: ->
    @div class: 'sloc inline-block', =>
      @span class: 'all', outlet: 'allSloc'

  initialize: ->
    atom.workspaceView.command "sloc:update", => @update()
    @subscribe atom.workspaceView.statusBar, 'active-buffer-changed', @update
    atom.workspaceView.statusBar.subscribeToBuffer 'saved modified-status-changed', @update
    
  afterAttack: ->
    @update()

  # Tear down any state and detach
  destroy: ->
    @detach()

  update: ->
    @status = @getSlocInfo?()
    @allSloc?.text "Loc: " + @status?.loc + "\tSloc: " + @status?.sloc + "\tCLoc: " + @status?.cloc
      
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
    
