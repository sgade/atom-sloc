{View} = require 'atom'
sloc = require 'sloc'

module.exports =
class SlocView extends View
  @status = {}
  
  @content: ->
    @div class: 'sloc overlay from-top', =>
      @div class: "message", =>
        @div outlet: "viewSloc"

  initialize: (serializeState) ->
    atom.workspaceView.command "sloc:toggle", => @toggle()
    @status = @getSloc

  # Returns an object that can be retrieved when package is activated
  serialize: ->
    @status

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    if !@hasParent()
      @status = @getSloc()
      @viewSloc.text "Loc: " + @status?.loc + "\tSloc: " + @status?.sloc + "\tCLoc: " + @status?.cloc
      atom.workspaceView.append(this)
    else
      @destroy()
      
  getSloc: ->
    editor = @getCurrentEditor()
    
    content = editor.editor.buffer.lines.join('\n');
    language = "coffeescript"
    
    stats = sloc content, language
    
    console.log stats
    stats
    
  getCurrentEditor: ->
    editorArray = atom.workspaceView.getEditorViews().filter( (editor) ->
      editor.active
    )
    editorArray[0]
    
