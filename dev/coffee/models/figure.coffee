Backbone = require 'backbone', $ = require 'jquery', _ = require 'underscore'
Events   = require '../events/event'

# 入力値
module.exports = class Figure extends Backbone.Model

  defaults:
    dot         : false
    value       : 0
    decimalPoint: 0
    isNew       : true
    # 計算結果となった第一数値
    firstFigure :null
    # 計算結果となった第二数値
    secondFigure:null
    # 計算に使用される演算子
    operand     :null

  initialize : (attrs) ->
    value = @get 'value'
    values = "#{value}".split '.'
    if values.length == 2
      @set
        'dot'          : true
        'decimalPoint' : values[1].length + 1

  addDigit : (digit) ->
    @set 'isNew', false

    if !/\d/.test(digit)
      console.error "#{digit} is not a digit."
      return

    if @get('dot')
      digit = digit * Math.pow 0.1, @get('decimalPoint')
      @set 'decimalPoint', @get('decimalPoint') + 1
      @set 'value', @get('value') + digit

    else
      value = @get('value')
      value = value + '' + digit if value
      value = value + digit if !value
      @set 'value', value*1

  dot : ->
    if @get('dot')
      console.error 'already dotted.'
      return
    @set
      'dot'         : true
      'decimalPoint': 1
      'isNew'       : false

  operand :(operand) ->
    @set
      'operand'     : operand
      'isNew'       : false

  delete : ->
    if @get 'dot'
      point = @get('decimalPoint') - 1
      if point >= 0
        @set 'decimalPoint', point

      if point <= 0
        @set 'decimalPoint', 0
        @set 'dot', false

    value = @get 'value'
    if !value
      return
    value = "#{value}".substring(0, "#{value}".length-1)
    @set 'value', value*1

  # @Override
  isNew : ->
    @get 'isNew'

  validate : ->
    value = @get('value')
    error
    if  !_.isNumber(value)
      error = "#{value} is not a number"
    else if _.isNaN(value)
      error = "value is NaN"
    else if !_.isFinite(value)
      error = "value is Infinite"

    if error
      console.error error
      Events.trigger 'error:input', error
      return error

  getDisplayValue : ->
    figure
    if /^\d+$/.test(@get 'value') and (@get 'dot')
      figure = (@get 'value') + '.'
    else
      figure = @get 'value'

    splitted = ""
    figure = "#{figure}".split('.')
    natural = figure[0]

    for digit,i in natural.split('').reverse()
      if i and i % 3 == 0 and digit != '-'
        splitted = ',' + splitted
      splitted = digit + splitted

    if figure.length == 2
      return "#{splitted}.#{figure[1]}"
    else
      return splitted

  calculate : (other) ->
    switch @get 'operand'
      when '＋'
        return @plus other
      when 'ー'
        return @minus other
      when '×'
        return @multiply other
      when '÷'
        return @devide other

  plus : (other) ->
    newValue = @get('value') + other.get('value')
    new Figure(value:newValue, firstFigure:@, secondFigure:other, operand:'＋')

  minus : (other) ->
    newValue = @get('value') - other.get('value')
    new Figure(value:newValue, firstFigure:@, secondFigure:other, operand:'ー')

  multiply : (other) ->
    newValue = @get('value') * other.get('value')
    new Figure(value:newValue, firstFigure:@, secondFigure:other, operand:'×')

  devide : (other) ->
    newValue = @get('value') / other.get('value')
    new Figure(value:newValue, firstFigure:@, secondFigure:other, operand:'÷')

  invert : ->
    @set 'value', @get('value') * -1
