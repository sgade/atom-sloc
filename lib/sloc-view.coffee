module.exports =
class SlocView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('sloc')
    @element.classList.add('inline-block')

    # Create message element
    @message = document.createElement('span')
    @message.classList.add('message')
    @element.appendChild(@message)
    
    @setSlocInfo null

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()
    
  getElement: ->
    @element
    
  setSlocInfo: (status) ->
    text = null
    if status
      text = "Lines: " + status?.total + "\tSource: " + status?.source + "\tComments: " + status?.comment + "\tEmpty: " + status?.empty
    else
      text = "Sloc unavailable"
    @message.textContent = text
