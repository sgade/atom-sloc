SlocView = require './sloc-view'
{CompositeDisposable} = require 'atom'
sloc = require 'sloc'

module.exports = Sloc =
  slocView: null
  subscriptions: null
  
  statusBar: null

  activate: (state) ->
    @slocView = new SlocView(state.slocViewState)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'sloc:toggle': => @toggle()
    
    @subscriptions.add atom.workspace.observeTextEditors (editor) =>
      @subscriptions.add editor.onDidStopChanging =>
        @update()
    
  consumeStatusBar: (statusBar) ->
    @statusBar = statusBar
    @statusBarTile = statusBar.addLeftTile(item: @slocView.getElement(), priority: 100)
    @update()

  deactivate: ->
    @subscriptions.dispose()
    @statusBarTile?.destroy
    @statusBarTile = null

  serialize: ->
    slocViewState: @slocView.serialize()

  toggle: ->
    if !@statusBar
      return
    if @statusBar.getLeftTiles().indexOf(@statusBarTile) != -1
      @statusBarTile.destroy()
    else
      @consumeStatusBar(@statusBar)
      
  update: ->
    editor = atom.workspace.getActiveTextEditor()
    if not editor
      return
    
    content = editor.getBuffer().getLines().join('\n')
    language = editor.getGrammar().name.toLowerCase()
    language = @checkLanguage language
    
    try
      info = sloc content, language
      console.log info
      @slocView.setSlocInfo info
    catch e
      if e instanceof TypeError
        # unsupported language probably
        @slocView.setSlocInfo null
      else
        throw e
        
  checkLanguage: (lang) ->
    if lang == 'c++' || lang == 'cpp'
      return 'c' # C++ seems to be handled as C
    return lang
