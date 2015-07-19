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
    'click'     : 'click'
    'mouseover' : 'mouseover'
    'mouseout'  : 'mouseout'

  initialize : (params) ->
    @eventName = params.eventName
    _.bindAll @, 'click', 'mouseover', 'mouseout', 'keypress'
    Events.on 'keypress:digit', @keypress
    Events.on 'keypress:operator', @keypress
    Events.on 'keypress:dot', @keypress
    Events.on 'keypress:clear', @keypress

  render : ->
    @$el.addClass('btn btn-default')
    @$el.text(@model.get 'value')

  click : ->
    Events.trigger "click:#{@eventName}", @model.get 'value'

  mouseover : ->

  mouseout : ->

  keypress : (value) ->
    if value == @model.get 'value'
      @$el.addClass 'btn-primary'
      @click()
    else
      @$el.removeClass 'btn-primary'
