Backbone = require 'backbone', $ = require 'jquery', _ = require 'underscore'
Events = require '../events/event'

module.exports = class KeyControl extends Backbone.View

  operands :
    plus     : 43 # shift
    minus    : 45
    multiply : 42 # shift
    devide   : 47
    equal    : 13

  el : 'body'

  events :
    'keypress' : 'keypress'

  keypress :(e) ->
    keyCode = e.keyCode
    isShift = e.shiftKey

    # 0-9
    if keyCode in [48..57]
      Events.trigger 'keypress:digit', keyCode - 48 unless isShift

    # 演算子
    if keyCode in _.values @operands
      Events.trigger 'keypress:operand', '＋' if keyCode == 43 and isShift
      Events.trigger 'keypress:operand', 'ー' if keyCode == 45 and !isShift
      Events.trigger 'keypress:operand', '×'  if keyCode == 42 and isShift
      Events.trigger 'keypress:operand', '÷'  if keyCode == 47 and !isShift
      Events.trigger 'keypress:operand', '＝' if keyCode == 13 and !isShift

    # ドット
    Events.trigger 'keypress:dot', '.' if keyCode == 46 and !isShift
