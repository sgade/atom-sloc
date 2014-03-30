{View} = require 'atom'
sloc = require 'sloc'

module.exports =
class SlocView extends View
  @content: ->
    @div class: 'sloc inline-block', =>
      @span class: 'all', outlet: 'allSloc'

  initialize: ->
    @supportedLanguages = [ "coffeescript", "c", "c++", "css", "scss", "go", "html", "java", "javascript", "python", "php" ]
    
    statusBar = atom.workspaceView.statusBar
    atom.workspaceView.command "sloc:update", =>
      @update()
    @subscribe atom.workspaceView, 'editor:grammar-changed', =>
      @update()
    @subscribe statusBar, 'active-buffer-changed', =>
      @update()
    statusBar.subscribeToBuffer 'saved modified-status-changed', =>
      @update()
    
  # Update after load
  afterAttach: ->
    @update()

  # Tear down any state and detach
  destroy: ->
    @unsubscribe()
    @detach()

  update: ->
    status = @getSlocInfo()
    if status
      @allSloc.text "Loc: " + status?.loc + "\tSloc: " + status?.sloc + "\tCLoc: " + status?.cloc
    else
      @allSloc.text ""
      
  getSlocInfo: ->
    editor = @getCurrentEditor()
    
    stats = sloc content, language
    content = editor.buffer.lines.join('\n');
    if @isLanguageSupported language
      stats
    
    stats
    
  getCurrentEditor: ->
    editorArray = atom.workspaceView.getEditorViews().filter( (editor) ->
      editor.active
    )
    editorArray[0].editor
    
