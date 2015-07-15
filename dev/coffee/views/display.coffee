Backbone = require 'backbone', $ = require 'jquery', _ = require 'underscore'
module.exports = Backbone.View.extend

  el : '#display'

  update : (value) ->
    @$el.text value
