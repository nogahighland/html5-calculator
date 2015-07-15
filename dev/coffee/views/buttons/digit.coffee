Events = require '../../events/event'
Button = require './button'

# 数字ボタンViewです。
# 初期化時に'digit'をキーとしたモデルの値を整数で渡します。
module.exports = Button.extend

  className : 'digit'

  # 数字押下イベント
  click : ->
    Events.trigger('click:digit', @model.get 'digit')
