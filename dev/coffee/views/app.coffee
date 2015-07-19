Backbone   = require 'backbone', $ = require 'jquery', _ = require 'underscore'
Display    = require './display'
Button     = require './button'
KeyControl = require './key-control'
AppModel   = require '../models/app'
Events     = require '../events/event'

# 電卓アプリ全体のビュー・コントローラ
class App extends Backbone.View

  el : '#wrapper'

  # 初期化処理
  initialize : ->
    _.bindAll @, 'clickDigit', 'clickClear', 'clickOperator', 'clickDot', 'clickInvert', 'clickPercent'

    @model = new AppModel()
    @render()

    @model.on 'change:display', _.bind((model, value) ->
      @display.update value
    ,@)

    Events.on 'click:digit', @clickDigit
    Events.on 'click:dot', @clickDot
    Events.on 'click:clear', @clickClear
    Events.on 'click:operator', @clickOperator
    Events.on 'click:invert', @clickInvert
    Events.on 'click:percent', @clickPercent

    # キーコントロール
    @keyControl = new KeyControl

  # 初期描画
  render : ->
    @display    = new Display

    buttons     = []
    # 数字
    for digit in [0..9]
      digitView = new Button(
        el        : "#digit-#{digit}.digit"
        model     : new Backbone.Model(value:digit)
        eventName : 'digit'
      )
      buttons.push digitView

    # 演算子
    ## +
    @plus       = new Button(
      el        : '#plus.operator'
      model     : new Backbone.Model(value:'＋')
      eventName : 'operator'
    )
    buttons.push @plus

    ## -
    @minus      = new Button(
      el        : '#minus.operator'
      model     : new Backbone.Model(value:'ー')
      eventName : 'operator'
    )
    buttons.push @minus

    ## *
    @multiply   = new Button(
      el        : '#multiply.operator'
      model     : new Backbone.Model(value:'×')
      eventName : 'operator'
    )
    buttons.push @multiply

    ## /
    @devide     = new Button(
      el        : '#devide.operator'
      model     : new Backbone.Model(value:'÷')
      eventName : 'operator'
    )
    buttons.push @devide

    ## /
    @equal      = new Button(
      el        : '#equal.operator'
      model     : new Backbone.Model(value:'＝')
      eventName : 'operator'
    )
    buttons.push @equal

    # ドット
    @dot        = new Button(
      el        : '#dot.operator'
      model     : new Backbone.Model(value:'.')
      eventName : 'dot'
    )
    buttons.push @dot

    # クリア
    @clear      = new Button(
      el        : '#clear.operator'
      model     : new Backbone.Model(value:'C')
      eventName : 'clear'
    )
    buttons.push @clear

    # 反転
    @invert     = new Button(
      el        : '#invert.operator'
      model     : new Backbone.Model(value:'+/-')
      eventName : 'invert'
    )
    buttons.push @invert

    # %
    @percent     = new Button(
      el        : '#percent.operator'
      model     : new Backbone.Model(value:'%')
      eventName : 'percent'
    )
    buttons.push @percent

    for button in buttons
      button.render()

    buttons = null

  clickDigit   : (digit) ->
    @model.updateFigure digit

  clickClear   : ->
    @model.clear()

  clickOperator : (operator) ->
    @model.updateOperator operator

  clickDot     : ->
    @model.dot()

  clickInvert  : ->
    @model.invert()

  clickPercent : ->
    @model.percent()

new App
