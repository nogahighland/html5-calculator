Backbone = require 'backbone', $ = require 'jquery', _ = require 'underscore'
Events   = require '../events/event'

module.exports = class ErrorView extends Backbone.View

  el       : '#error-container'

  initialize : ->
    _.bindAll @, 'update', 'clear'
    Events.on 'error:input', @update
    Events.on 'click:clear', @clear

  update : (error) ->
    @$el.find('#message').text '数値が大きすぎます。ESCキーまたはCでリセットしてください。'

  clear : ->
    @$el.find('#message').text ''
