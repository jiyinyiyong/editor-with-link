
class EditorWithlink
  constructor: ->
    @$el = $ @makeHtml()
    @syncText()
    @setupListener()
    @showViewer()

  $: (query) ->
    @$el.find(query)

  makeHtml: ->
    viewer = "<div class='link-viewer link-views'></div>"
    editor = "<textarea class='link-editor link-views'></textarea>"
    "<div class='editor-with-link'>#{viewer}#{editor}</div>"

  syncText: ->
    @$('.link-viewer').html (@convert @$('.link-editor').val())
    height = @$('.link-viewer').height()
    @$el.css 'height', height
    @$('.link-editor').css 'height', height

  setupListener: ->
    @$el.on 'keyup', '.link-editor', =>
      @syncText()
    @$el.on 'blur', '.link-editor', =>
      @showViewer()
    @$el.on 'click', '.link-viewer', =>
      @showEditor()
    @$el.on 'click', '.link-viewer a', (event) =>
      @stopPropagation event

  stopPropagation: (event) ->
    event.stopPropagation()
    on

  showEditor: ->
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
    .replace /(https?\:\/\/[^\s&,;"'<]+)/g,
      '<a href="$1" target="_blank">$1</a>'

  recordLength: ->
    selection = window.getSelection()
    {anchorNode, anchorOffset} = selection
    console.log anchorNode, anchorOffset
    range = new Range
    range.setEnd anchorNode, anchorOffset
    range.setStartBefore @$('.link-viewer').get(0)
    selection.addRange range
    selection.toString().length

  simulateCaret: (length) ->
    @$('.link-editor').get(0).selectionStart = length
    @$('.link-editor').get(0).selectionEnd = length