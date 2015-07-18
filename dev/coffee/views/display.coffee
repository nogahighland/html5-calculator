Backbone = require 'backbone', $ = require 'jquery', _ = require 'underscore'

module.exports = class Display extends Backbone.View

  el : '#display'

  # 表示を更新します
  update : (value) ->
    @$el.text value
