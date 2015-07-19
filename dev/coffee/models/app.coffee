Backbone = require 'backbone', $ = require 'jquery', _ = require 'underscore'
Figure   = require './figure.coffee'

# 電卓全体のモデルです。
module.exports = class App extends Backbone.Model

  defaults :
    # 第一数値
    operand1 : null
    # 第二数値
    operand2: null
    # 結果
    result      : null
    # 表示値
    display     : 0

  initialize : ->
    for attr in ['operand1', 'operand2', 'result']
      @set attr, new Figure

  # 整数の入力のバリデートを行ってoperand1, operand2, displayを更新する
  updateFigure : (digit) ->
    figure
    if _.isEmpty @get('operand1').get('operator')
      figure = @get 'operand1'
    else
      figure = @get 'operand2'

    figure.addDigit(digit)
    if figure.isValid()
      @set 'display', figure.getDisplayValue()

  # 初期値に対する演算子
  updateOperator: (operator) ->
    f1     = @get 'operand1'
    f2     = @get 'operand2'
    result = @get 'result'
    if operator == '＝'
      update
      if !f1.isNew() and !f2.isNew()
        update = f1.calculate(f2)
      else
        update = result.calculate(result.get 'operand2')

      if update.isValid()
        @set
          'result'      : update
          'display'     : update.getDisplayValue()
          'operand1' : new Figure
          'operand2': new Figure

    else
      if f1.isNew() and f2.isNew() and (result and result.isNew())
        result.operator operator
        @set
          operand1:　result
          result     :　null

      if !f1.isNew() and !f2.isNew()
        update = f1.calculate(f2)

        if update.isValid()
          @set
            'result'      : update
            'display'     : update.getDisplayValue()
            'operand1' :new Figure
            'operand2':new Figure

      else if f2.isNew()
        f1.operator operator
      else
        f2.operator operator

  dot : ->
    figure
    if (@get 'operand1').isNew()
      figure = @get 'operand1'
    else
      figure = @get 'operand2'

    figure.dot()
    if figure.isValid()
      @set 'display', figure.getDisplayValue()

  invert : ->
    f1     = @get 'operand1'
    f2     = @get 'operand2'
    update
    if !f1.isNew()
      f1.invert()
      update = f1
    else
      f2.invert()
      update = f2

    if update.isValid()
      @set
        'display'     : update.getDisplayValue()

  percent : ->
    f1     = @get 'operand1'
    f2     = @get 'operand2'
    update
    if !f1.isNew()
      f1.percent()
      update = f1
    else
      f2.percent()
      update = f2

    if update.isValid()
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
