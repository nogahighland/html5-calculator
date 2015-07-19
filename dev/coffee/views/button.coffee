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
module.exports = class Button extends Backbone.View

  tagName : 'button'

  events :
    'click' : 'click'

  initialize : (params) ->
    @eventName = params.eventName
    _.bindAll @, 'click', 'keypress', 'keyup'
    for type in ['keypress', 'keyup']
      for name in ['digit', 'operator', 'dot', 'clear', 'percent']
        Events.on "#{type}:#{name}", @[type]

  render : ->
    @$el.text(@model.get 'value')

  click : ->
    Events.trigger "click:#{@eventName}", @model.get 'value'

  keypress : (value) ->
    if value == @model.get 'value'
      @$el.addClass 'btn-pressed'
      @click()
    else
      @$el.removeClass 'btn-pressed'

  keyup : (value) ->
    if value == 'C'== @model.get 'value'
      @click()
    @$el.removeClass 'btn-pressed'
