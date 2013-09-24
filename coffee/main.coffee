
window.onload = ->
  editor = new EditorWithLink

  $('body').append editor.$el

  editor.setText """demo
  jiyinyiyong@qq.com
  http://qq.com
  """
  console.log editor.getText()