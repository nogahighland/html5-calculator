Backbone = require 'backbone', $ = require 'jquery', _ = require 'underscore'
Events = require '../events/event'

module.exports = class KeyControl extends Backbone.View

  el : 'body'

  events :
    'keypress' : 'key'
    'keyup'    : 'key'

  key :(e) ->
    keyCode = e.keyCode
    isShift = e.shiftKey
    type = e.type

    console.log type, keyCode, isShift

    # 0-9
    if keyCode in [48..57]
      Events.trigger "#{type}:digit", keyCode - 48 unless isShift

    # 演算子
    Events.trigger "#{type}:operator", '＋' if keyCode in [43,187] and isShift
    Events.trigger "#{type}:operator", 'ー' if keyCode in [45,189] and !isShift
    Events.trigger "#{type}:operator", '×'  if keyCode in [42,222] and isShift
    Events.trigger "#{type}:operator", '÷'  if keyCode in [47,191] and !isShift
    Events.trigger "#{type}:operator", '＝' if keyCode == 13 and !isShift

    # ドット
    Events.trigger "#{type}:dot", '.' if keyCode in [46,190] and !isShift

    # クリア
    Events.trigger "#{type}:clear", 'C' if keyCode in [99,67] and !isShift
