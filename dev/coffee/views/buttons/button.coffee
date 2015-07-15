Backbone = require 'backbone', $ = require 'jquery', _ = require 'underscore'

# ボタンの抽象クラスです。
module.exports = Backbone.View.extend

  tagName : 'button'

  events :
    'click' : 'click'
    'mouseover' : 'mouseover'
    'mouseover' : 'mouseout'

  initialize : ->
    _.bindAll @, 'click', 'mouseover', 'mouseout'

  click : ->
    console.log 'クリック'

  mouseover : ->
    console.log '色を変える'

  mouseout : ->
    console.log '色を戻す'
