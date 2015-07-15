Backbone       = require 'backbone', $ = require 'jquery', _ = require 'underscore'

# 電卓全体のモデルです
module.exports = Backbone.Model.extend
  update      : ->
  clear       :->
  allClear    :->
    @operand      = null
    @firstfigure  = null
    @secondFigure = null
    @result       = null
    @display      = null
  operand     :null
  firstfigure :null
  secondFigure:null
  result      :null
  display     :null
