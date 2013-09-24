
window.onload = ->
  editor = new EditorWithlink

  $('body').append editor.$el

  editor.setText """demo
  jiyinyiyong@qq.com
  http://qq.com
  """
  console.log editor.getText()