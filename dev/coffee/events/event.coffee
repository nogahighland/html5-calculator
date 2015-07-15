Backbone = require 'backbone', $ = require 'jquery', _ = require 'underscore'

# view同士のイベントディスパッチャ
module.exports = _.extend({}, Backbone.Events)
