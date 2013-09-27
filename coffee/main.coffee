
window.onload = ->

  text = """demo
  jiyinyiyong@qq.com
  http://qq.com
  """

  editor = new EditorWithLink {text}

  $('body').append editor.$el