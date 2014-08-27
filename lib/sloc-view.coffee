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
      @allSloc.text "Lines: " + status?.loc + "\tSource: " + status?.sloc + "\tComments: " + status?.cloc + "\tEmpty: " + status?.nloc
      @allSloc.show()
    else
      @allSloc.hide()
      
  getSlocInfo: ->
    editor = @getCurrentEditor()
    if not editor
      return
    
    content = editor.buffer.lines.join('\n');
    language = editor.getGrammar().name.toLowerCase();
    language = @transformLanguage language
    
    if @isLanguageSupported language
      sloc content, language
      
  transformLanguage: (lang) ->
    if lang == 'c++'
      return 'cpp'
    return lang
    
  isLanguageSupported: (lang) ->
    matches = @supportedLanguages.filter (sLang) ->
      true if sLang is lang
    if matches?.length > 0
      true
    else
      false
    
  getCurrentEditor: ->
    editorArray = atom.workspaceView.getEditorViews().filter( (editor) ->
      editor.active
    )
    if editorArray.length > 0
      editorArray[0].editor
    
