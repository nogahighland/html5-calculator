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

  # 数値を更新する対象をoperand1, operand2から定め、
  # displayを更新する
  updateFigure : (digit) ->
    f1 = @get 'operand1'
    f2 = @get 'operand2'
    r  = @get 'result'
    figure
    # XX + YY + まで入力終えたところ
    if f1.isNew() and f2.isNew() and r.get 'operator'
      @set
        operand1 : r
        result   : new Figure

      figure = f2
      f2.addDigit digit

      if figure.isValid()
        @set
          display           : figure.getDisplayValue()
          'display-process' : "#{r.get('value')} #{r.get('operator')} #{f2.get('value')}"

    # XX + YY の XX を入力中
    else
      if _.isEmpty f1.get('operator')
        figure = @get 'operand1'
      else
        figure = @get 'operand2'

      figure.addDigit(digit)
      if figure.isValid()
        @set
          display           : figure.getDisplayValue()
          'display-process' : figure.getDisplayValue()

  # 演算子をどの数値に適用するか決定し、設定する
  updateOperator: (operator) ->
    f1     = @get 'operand1'
    f2     = @get 'operand2'
    result = @get 'result'
    if operator == '＝'
      update
      # XX + YY の YY のみを入力済みの時
      if !f1.isNew() and f2.isNew()
        update = f1.calculate f1
      # XX + YY を入力済みの時
      else if !f1.isNew() and !f2.isNew()
        update = f1.calculate f2
      # XX + YY の 結果を出し終わった直後
      # または計算結果を出していない時
      else if result and result.isNew()
        update = result.calculate(result.get 'operand2')

      if !update.get('operand1')
        return

      if update.isValid()
        @set
          'result'          : update
          'display'         : update.getDisplayValue()
          'operand1'        : new Figure
          'operand2'        : new Figure
          'display-process' : "#{update.get('operand1').get('value')} #{update.get('operand1').get('operator')} #{update.get('operand2').get('value')}"

    else
      # -----------------------------------
      # =以外の演算子
      # -----------------------------------

      if f1.isNew() and f2.isNew()
        figure
        if result and result.get 'operator'
          # 計算結果を出し終わった直後
          figure = result
        else
          # 全てが未入力の時
          figure = f1

        figure.operator operator
        @set
          operand1          :　figure
          result            :　null
          'display-process' : "#{figure.get('value')} #{operator}"

      # XX + YY の YY のみを入力済みの時
      else if !f1.isNew() and f2.isNew()
        f1.operator operator
        @set
          'display-process' : f1.getDisplayValue() + ' ' + operator

      # XX + YY を入力済み
      else if !f1.isNew() and !f2.isNew()
        update = f1.calculate(f2)
        update.operator operator

        if update.isValid()
          @set
            'result'          : update
            'display'         : update.getDisplayValue()
            'operand1'        : new Figure
            'operand2'        : new Figure
            'display-process' : "#{update.get('value')} #{operator}"

      else
        f2.operator operator

  dot : ->
    f1 = @get 'operand1'
    f2 = @get 'operand2'
    r  = @get 'result'
    figure
    # XX + YY + まで入力終えたところ
    if r and r.get 'operator'
      @set
        operand1 : r
        result   : new Figure
      figure = f2
    else if _.isEmpty f1.get('operator')
      figure = f1
    else
      figure = f2

    figure.dot()
    if figure.isValid()
      @set
        'display'         : figure.getDisplayValue()
        'display-process' : figure.getDisplayValue()

  invert : ->
    f1 = @get 'operand1'
    f2 = @get 'operand2'
    r  = @get 'result'
    figure
    # XX + YY + まで入力終えたところ
    if r and r.get 'operator'
      @set
        operand1 : r
        result   : new Figure
      figure = r
    else if _.isEmpty f1.get('operator')
      figure = f1
    else
      figure = f2

    figure.invert()
    if figure.isValid()
      @set
        'display'         : figure.getDisplayValue()
        'display-process' : figure.getDisplayValue()

  percent : ->
    f1 = @get 'operand1'
    f2 = @get 'operand2'
    r  = @get 'result'
    figure
    # XX + YY + まで入力終えたところ
    if r and r.get 'operator'
      @set
        operand1 : r
        result   : new Figure
      figure = r
    else if _.isEmpty f1.get('operator')
      figure = f1
    else
      figure = f2

    figure.percent()
    if figure.isValid()
      @set
        'display'         : figure.getDisplayValue()
        'display-process' : figure.getDisplayValue()

  delete : ->
    f1     = @get 'operand1'
    f2     = @get 'operand2'
    update
    if !f1.isNew() and f2.isNew()
      f1.delete()
      update = f1
    else if !f2.isNew()
      f2.delete()
      update = f2

    if update.isValid()
      @set
        'display'         : update.getDisplayValue()
        'display-process' : update.getDisplayValue()

  # クリアする
  clear : ->
    @set 'display', 0
    @set 'display-process', 0
    super()
    @initialize()
