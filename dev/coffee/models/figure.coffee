Backbone = require 'backbone', $ = require 'jquery', _ = require 'underscore'
__ = require 'lodash'
Events   = require '../events/event'

# 入力値
module.exports = class Figure extends Backbone.Model

  defaults:
    dot         : false
    value       : 0
    # 現在小数点第何位までか
    decimalPoint: 0
    # 新規にインスタンスが生成されて、入力によって変わったか
    isNew       : true
    # 計算結果となった第一数値
    operand1    :null
    # 計算結果となった第二数値
    operand2    :null
    # 計算に使用される演算子
    operator    :null

  initialize : (attrs) ->
    value = @get 'value'
    values = "#{value}".split '.'
    if values.length == 2
      @set
        'dot'          : true
        'decimalPoint' : values[1].length

  addDigit : (digit) ->
    @set 'isNew', false

    if !/\d/.test(digit)
      console.error "#{digit} is not a digit."
      return

    if @get('dot')
      decimalPoint = @get('decimalPoint')
      naturalize   = if decimalPoint then Math.pow(10, decimalPoint) else 1
      naturalized  = @get('value') * naturalize
      value        = ("#{naturalized}#{digit}" * 1) / (naturalize * 10)
      @set
        'value'        : value
        'decimalPoint' : decimalPoint + 1
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
      'decimalPoint': 0
      'isNew'       : false

  operator :(operator) ->
    @set
      'operator'     : operator
      'isNew'       : false

  delete : ->
    if @get 'dot'
      point = @get('decimalPoint') - 1
      if point >= 0
        @set 'decimalPoint', point

      if point < 0
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
      console.error error,value
      Events.trigger 'error:input', error
      return error

  getDisplayValue : ->
    figure
    if /^\d+$/.test(@get 'value') and (@get 'dot')
      figure = (@get 'value') + '.'
    else
      figure = @get 'value'

    splitted = ""

    match = /(\d)\.?(\d*)e(-|\+)(\d+)/.exec figure
    if match
      number   = match[1] + match[2]
      posiNega = match[3]
      col      = match[4]

      if posiNega == '+'
        return @split(number + (__.repeat 0, (col - number.length)))
      else
        return '0.' + (__.repeat 0, (col - number.length)) + number

    figure = "#{figure}".split('.')
    natural = figure[0]

    splitted = @split natural

    if figure.length == 2
      decimal = figure[1]
      if !decimal and @get 'decimalPoint'
        decimal = __.repeat '0', _(@get 'decimalPoint')

      return "#{splitted}.#{decimal}"
    else
      return splitted

  split : (natural) ->
    splitted = ''
    for digit,i in natural.split('').reverse()
      if i and i % 3 == 0 and digit != '-'
        splitted = ',' + splitted
      splitted = digit + splitted
    splitted

  calculate : (other) ->
    switch @get 'operator'
      when '＋'
        return @plus other
      when 'ー'
        return @minus other
      when '×'
        return @multiply other
      when '÷'
        return @devide other
      else
        return @

  plus : (other) ->
    newValue = @get('value') + other.get('value')
    new Figure(value:newValue, operand1:@, operand2:other, operator:'＋')

  minus : (other) ->
    newValue = @get('value') - other.get('value')
    new Figure(value:newValue, operand1:@, operand2:other, operator:'ー')

  multiply : (other) ->
    newValue = @get('value') * other.get('value')
    new Figure(value:newValue, operand1:@, operand2:other, operator:'×')

  devide : (other) ->
    newValue = @get('value') / other.get('value')
    new Figure(value:newValue, operand1:@, operand2:other, operator:'÷')

  invert : ->
    @set 'value', @get('value') * -1

  percent : ->
    @set 'value', @get('value') / 100
