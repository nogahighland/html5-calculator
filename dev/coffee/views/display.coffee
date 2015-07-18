Backbone = require 'backbone', $ = require 'jquery', _ = require 'underscore'

module.exports = class Display extends Backbone.View

  el : '#display'

  update : (value) ->
    @$el.text value
