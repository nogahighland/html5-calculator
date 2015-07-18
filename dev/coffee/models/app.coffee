Backbone = require 'backbone', $ = require 'jquery', _ = require 'underscore'
Figure   = require './figure.coffee'

# 電卓全体のモデルです。
module.exports = class App extends Backbone.Model

  defaults :
    # 第一数値
    firstFigure : null
    # 第二数値
    secondFigure: null
    # 結果
    result      : null
    # 表示値
    display     : 0

  initialize : ->
    for attr in ['firstFigure', 'secondFigure', 'result']
      @set attr, new Figure

  # 整数の入力のバリデートを行ってfirstFigure, secondFigure, displayを更新する
  updateFigure : (digit) ->
    figure
    if _.isEmpty @get('firstFigure').get('operand')
      figure = @get 'firstFigure'
    else
      figure = @get 'secondFigure'

    figure.addDigit(digit)
    if figure.isValid()
      @set 'display', figure.getDisplayValue()

  # 初期値に対する演算子
  updateOperand: (operand) ->
    f1     = @get 'firstFigure'
    f2     = @get 'secondFigure'
    result = @get 'result'
    if operand == '＝'
      update
      if !f1.isNew() and !f2.isNew()
        update = f1.calculate(f2)
      else
        update = result.calculate(result.get 'secondFigure')

      if update.isValid()
        @set
          'result'      : update
          'display'     : update.getDisplayValue()
          'firstFigure' : new Figure
          'secondFigure': new Figure

    else
      if f1.isNew() and f2.isNew() and (result and result.isNew())
        result.operand operand
        @set
          firstFigure:　result
          result     :　null

      if !f1.isNew() and !f2.isNew()
        update = f1.calculate(f2)

        if update.isValid()
          @set
            'result'      : update
            'display'     : update.getDisplayValue()
            'firstFigure' :new Figure
            'secondFigure':new Figure

      else if f2.isNew()
        f1.operand operand
      else
        f2.operand operand

  dot : ->
    figure
    if (@get 'firstFigure').isNew()
      figure = @get 'firstFigure'
    else
      figure = @get 'secondFigure'

    figure.dot()
    if figure.isValid()
      @set 'display', figure.getDisplayValue()

  invert : ->
    f1     = @get 'firstFigure'
    f2     = @get 'secondFigure'
    update
    if !f1.isNew()
      f1.invert()
      update = f1
    else
      f2.invert()
      update = f2

    if figure.isValid()
      @set
        'display'     : update.getDisplayValue()

  # クリアする
  clear : ->
    @set 'display', 0
    super()
    @initialize()

  # 全てをクリアする
  # allClear     :->
  #   @clear()
