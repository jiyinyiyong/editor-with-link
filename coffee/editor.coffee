
class EditorWithlink
  constructor: ->
    @$el = $ @makeHtml()
    @syncText()
    @setupListener()
    @showViewer()

  regex:
    link: /((http|https|ftp|ftps)\:\/\/([a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?))/g
    email: /\b([A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4})\b/ig

  $: (query) ->
    @$el.find(query)

  makeHtml: ->
    viewer = "<div class='link-viewer link-views'></div>"
    editor = "<textarea class='link-editor link-views'></textarea>"
    "<div class='editor-with-link'>#{viewer}#{editor}</div>"

  syncText: ->
    @$('.link-viewer').html (@convert @$('.link-editor').val())
    height = @$('.link-viewer').css 'height'
    @$el.css 'height', height
    @$('.link-editor').css 'height', height

  setupListener: ->
    @$el.on 'keyup', '.link-editor', =>
      @syncText()
    @$el.on 'blur', '.link-editor', =>
      @showViewer()
    @$el.on 'click', '.link-viewer a', (event) =>
      @stopPropagation event
    @$el.on 'click', '.link-viewer', (event) =>
      @showEditor event

  stopPropagation: (event) ->
    event.stopPropagation()
    on

  showEditor: (event) ->
    unless event? and $(event.target).is 'a'
      length = @recordLength()
      @$('.link-editor').show().focus()
      @simulateCaret length

  showViewer: ->
    @$('.link-editor').hide()

  convert: (text) ->
    text
    .replace /</g,
      '&lt;'
    .replace />/g,
      '&gt;'
    .replace /\n/g,
      '<br>'
    .replace @regex.link,
      '<a href="$1" target="_blank" title="Go to $3">$1</a>'
    .replace @regex.email,
      '<a href="mailto:$1" title="Send mail to $1">$1</a>'

  recordLength: ->
    if window.getSelection?
      selection = window.getSelection()
      {anchorNode, anchorOffset} = selection
      startNode = @$('.link-viewer').get(0).childNodes[0]
      console.log anchorNode, anchorOffset
      range = document.createRange()
      range.setStart anchorNode, 0
      range.setEnd anchorNode, anchorOffset
      selection.addRange range
      selection.toString().length
    else
      0

  simulateCaret: (length) ->
    console.log 'semulting, ', length
    @$('.link-editor').get(0).selectionStart = length
    @$('.link-editor').get(0).selectionEnd = length

  getText: ->
    @$('.link-editor').val()

  setText: (text) ->
    @$('.link-editor').val text
    @syncText()