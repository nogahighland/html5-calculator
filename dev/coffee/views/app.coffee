Backbone = require 'backbone', $ = require 'jquery', _ = require 'underscore'
Display  = require './display'
Button   = require './button'
AppModel = require '../models/app'
Events   = require '../events/event'

# 電卓アプリ全体のビュー・コントローラ
App = Backbone.View.extend

  el : '#wrapper'

  # 初期化処理
  initialize : ->

    _.bindAll @, 'clickDigit', 'clickClear', 'clickOperand', 'clickDot'

    @model   = new AppModel()
    @render()

    @model.on 'change:display', _.bind((model, value) ->
      @display.update value
    ,@)

    Events.on 'click:digit', @clickDigit
    Events.on 'click:dot', @clickDot
    Events.on 'click:clear', @clickClear
    Events.on 'click:operand', @clickOperand

  # 初期描画
  render : ->
    @display = new Display()

    buttons  = []
    # 数字
    for digit in [0..9]
      digitView = new Button(
        el : "#digit-#{digit}.digit"
        model : new Backbone.Model(value:digit)
        eventName : 'digit'
      )
      buttons.push digitView

    # 演算子
    ## +
    @plus = new Button(
      el : '#plus.operand'
      model : new Backbone.Model(value:'＋')
      eventName : 'operand'
    )
    buttons.push @plus

    ## -
    @minus = new Button(
      el : '#minus.operand'
      model : new Backbone.Model(value:'ー')
      eventName : 'operand'
    )
    buttons.push @minus

    ## *
    @multiply = new Button(
      el : '#multiply.operand'
      model : new Backbone.Model(value:'×')
      eventName : 'operand'
    )
    buttons.push @multiply

    ## /
    @devide = new Button(
      el : '#devide.operand'
      model : new Backbone.Model(value:'÷')
      eventName : 'operand'
    )
    buttons.push @devide

    ## /
    @equal = new Button(
      el : '#equal.operand'
      model : new Backbone.Model(value:'＝')
      eventName : 'operand'
    )
    buttons.push @equal

    # ドット
    @dot = new Button(
      el : '#dot.operand'
      model : new Backbone.Model(value:'.')
      eventName : 'dot'
    )
    buttons.push @dot

    # クリア
    @clear = new Button(
      el : '#clear.operand'
      model : new Backbone.Model(value:'C')
      eventName : 'clear'
    )
    buttons.push @clear

    for button in buttons
      button.render()

    buttons = null

  clickDigit : (digit) ->
    @model.updateFigure digit

  clickClear : ->
    @model.clear()

  clickOperand : (operand) ->
    @model.updateOperand operand

  clickDot : ->
    @model.dot()

new App()
