Backbone = require 'backbone', $ = require 'jquery', _ = require 'underscore'
Events = require '../events/event'

# ボタンクラスです。
# コンストラクタ
#   - model:
#     'value'をキーとして渡すことで以下に反映されます。
#     - クリック時の値
#     - ボタンに表示される値
#   - eventName:
#     クリック時のイベント名に反映されます。
module.exports = Backbone.View.extend

  tagName : 'button'

  events :
    'click' : 'click'
    'mouseover' : 'mouseover'
    'mouseout' : 'mouseout'

  initialize : (params) ->
    @eventName = params.eventName
    _.bindAll @, 'click', 'mouseover', 'mouseout'

  render : ->
    @$el.addClass('btn btn-default')
    @$el.text(@model.get 'value')

  click : ->
    Events.trigger "click:#{@eventName}", @model.get 'value'

  mouseover : ->

  mouseout : ->
