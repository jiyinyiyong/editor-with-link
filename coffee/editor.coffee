
class EditorWithLink
  constructor: (@options) ->
    @options ?= {}
    @options.empty ?= 'Write here...'

    @$el = $ @makeHtml()
    @setupListener()
    @setText @options.text if @options.text
    @showViewer()
    @syncText()

  regex:
    link: /((http|https|ftp|ftps)\:\/\/([a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?))/g
    email: /\b([A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4})\b/ig

  $: (query) ->
    @$el.find(query)

  makeHtml: ->
    viewer = "<div class='link-viewer link-views'></div>"
    empty = "placeholder='#{@options.empty}'"
    editor = "<textarea class='link-editor link-views' #{empty}></textarea>"
    "<div class='editor-with-link'>#{viewer}#{editor}</div>"

  syncText: ->
    content = @$('.link-editor').val()
    @$('.link-viewer').html (@convert content)

  setupListener: ->
    @$el.on 'keyup', '.link-editor', =>
      setTimeout => @syncText()
    @$el.on 'blur', '.link-editor', =>
      @showViewer()
    @$el.on 'click', '.link-viewer a', (event) =>
      @stopPropagation event
    @$el.on 'click', (event) =>
      @whenFocus event

  whenFocus: (event) ->
    if $(event.target).is '.link-viewer'
      @showEditor event
    else if $(event.target).is '.editor-with-link'
      @showEditor event
      @simulateCaretEnd()

  stopPropagation: (event) ->
    event.stopPropagation()
    on

  showEditor: (event) ->
    unless event? and $(event.target).is 'a'
      length = @recordLength()
      @$('.link-editor').show()
      if event?
        @$('.link-editor').focus()
        @simulateCaret length

  showViewer: ->
    content = @$('.link-editor').val()
    if $.trim(content).length > 0
      @$('.link-editor').hide()

  convert: (text) ->
    text = text
    .replace /&((\w{2,8})|(#\d{2,8});)/g,
      '&amp;$1'
    .replace /</g,
      '&lt;'
    .replace />/g,
      '&gt;'
    .replace @regex.link,
      '<a href="$1" target="_blank" title="Go to $3">$1</a>'
    .replace @regex.email,
      '<a href="mailto:$1" title="Send mail to $1">$1</a>'
    .replace /\n/g,
      '<br>'
    text + '<br>'

  recordLength: ->
    if window.getSelection?
      selection = window.getSelection()
      {anchorNode, anchorOffset} = selection
      parentNode = @$('.link-viewer').get(0)
      # console.log anchorNode, anchorOffset
      range = document.createRange()
      range.setStartBefore parentNode if parentNode?
      range.setEnd anchorNode, anchorOffset if anchorNode?
      range.toString().length
      selection.removeAllRanges()
      selection.addRange range
      selection.toString().length
    else
      0

  simulateCaret: (length) ->
    try
      # console.log 'semulting, ', length
      @$('.link-editor').get(0).selectionStart = length
      @$('.link-editor').get(0).selectionEnd = length

  simulateCaretEnd: ->
    try
      length = @$('.link-editor').val().length
      @$('.link-editor').get(0).selectionStart = length
      @$('.link-editor').get(0).selectionEnd = length

  getText: ->
    @$('.link-editor').val()

  setText: (text) ->
    @$('.link-editor').val text
    @syncText()