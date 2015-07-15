Backbone        = require 'backbone', $ = require 'jquery', _ = require 'underscore'

Digit           = require './buttons/digit'

Plus            = require './buttons/operands/plus'
Minus           = require './buttons/operands/minus'
Multiple        = require './buttons/operands/multiple'
Devide          = require './buttons/operands/devide'
Equal           = require './buttons/operands/equal'

AppModel        = require '../models/app'

Events          = require '../events/event'

# 電卓アプリ全体のビュー・コントローラ
App             = Backbone.View.extend

  el : '#wrapper'

  initialize : ->

    _.bindAll @, 'clickDigit', 'clickClear', 'clickOperand', 'clickDot'

    @model      = new AppModel()

    for digit in [0..9]
      digitView = new Digit(digit:digit)
      digitView.$el

    @plus       = new Plus()
    @minus      = new Minus()
    @multiple   = new Multiple()
    @devide     = new Devide()
    @equal      = new Equal()

    Events.on 'click:digit', @clickDigit
    Events.on 'click:dot', @clickDot
    Events.on 'click:clear', @clickClear
    Events.on 'click:operand', @clickOperand

  clickDigit : (digit) ->

  clickClear : ->

  clickOperand : (operand) ->

  clickDot : ->

new App()
