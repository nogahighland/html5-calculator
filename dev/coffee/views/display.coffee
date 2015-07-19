Backbone = require 'backbone', $ = require 'jquery', _ = require 'underscore'

# 数字の表示領域です
module.exports = class Display extends Backbone.View

  el : '#display-container'

  initialize : ->
    @display = @$el.find('#display')
    @process = @$el.find('#display-process')
    @render()

  updateResult : (value) ->
    @display.text value

  updateProcess : (value) ->
    @process.text value

  render : ->
    @display.text '0'
    @process.text '0'
