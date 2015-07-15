Events = require '../../events/event'
Button = require './button'

# ドットボタン
module.exports = Button.extend

  id : 'dot'

  # 数字押下イベント
  click : ->
    Events.trigger('click:dot')
