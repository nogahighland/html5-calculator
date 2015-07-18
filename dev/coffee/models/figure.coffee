Backbone       = require 'backbone', $ = require 'jquery', _ = require 'underscore'

# 入力値
module.exports = class Figure extends Backbone.Model

  defaults:
    dot         : false
    value       : 0
    decimalPoint: 0

  initialize : ->
    @on 'change:value', (model, value, option)->
      # console.log "passed value is #{value}"


  addDigit : (digit) ->
    if !/\d/.test(digit)
      console.error "#{digit} is not a digit."
      return

    if @get('dot')
      @set 'decimalPoint', @get('decimalPoint') + 1
      digit = digit * Math.pow 0.1, @get('decimalPoint')
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

    @set 'dot', true

  delete : ->
    value = @get 'value'
    if !value
      return
    value = "#{value}".substring(0, "#{value}".length-1)
    @set 'value', value*1

  # @Override
  isNew : ->
    !!@previous()

  validate : ->
    value = @get('value')
    return "#{value} is not a number" if  !_.isNumber(value)
    return "value is NaN" if _.isNaN(value)
    return "value is Infinite" if !_.isFinite(value)
