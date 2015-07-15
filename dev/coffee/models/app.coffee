Backbone       = require 'backbone', $ = require 'jquery', _ = require 'underscore'

# 電卓全体のモデルです。
module.exports = Backbone.Model.extend

  defaults :
    # 演算子
    operand      :null
    # 第一数値
    firstFigure :null
    # 第二数値
    secondFigure:null
    # 結果
    result        :0
    # 表示値
    display      :null

  # 整数の入力のバリデートを行ってfirstFigure, secondFigure, displayを更新する
  updateFigure : (digit) ->
    if !/\d/.test("#{digit}")
      return

    if @isEmpty()
      @set 'firstFigure', digit
      @set 'display', digit

    else if @isFirstFigureInputProgressing()
      update = @get('firstFigure') + '' + digit
      update *= 1
      @set 'firstFigure', update
      @set 'display', update

    else if @isWaitingForSecondFigure()
      @set 'secondFigure', digit
      @set 'display', digit

    else if @isSecondFigureInputProgressing()
      update = @get('secondFigure') + '' + digit
      update *= 1
      @set 'secondFigure', update
      @set 'display', update

    else
      @set 'display', 'unexpected!'


  # 初期値に対する演算子
  updateOperand: (operand) ->
    if operand == '＝'
      f1 = 0
      f2 = 0

      if @isWaitingForSecondFigure()
        f1 = @get 'result'
        f2 = @get 'firstFigure'

      else if @isSecondFigureInputProgressing()
        f1 = @get 'firstFigure'
        f2 = @get 'secondFigure'

      update = @calculate(f1, f2, @get('operand'))
      @set 'display', update
      @set 'firstFigure', f2
      @set 'result', update
      @set 'secondFigure', null

    else

      @set 'operand', operand

  # 小数点のバリデートを行ってfirstFigure, secondFigure, displayを更新する
  dot          : ->
    @set 'display', '.'

  # クリアする
  clear        :->
    @set 'display', 0

  # 状態判定

  isEmpty : ->
    @get('firstFigure') == null and @get('secondFigure') == null and @get('operand') == null

  isFirstFigureInputProgressing: ->
    @get('firstFigure') != null and @get('secondFigure') == null and @get('operand') == null

  isWaitingForSecondFigure: ->
    @get('firstFigure') != null and @get('secondFigure') == null and @get('operand') != null

  isSecondFigureInputProgressing: ->
    @get('firstFigure') != null and @get('secondFigure') != null and @get('operand') != null

  calculate : (f1, f2, operand) ->
    console.log "#{f1}#{operand}#{f2}"
    switch operand
      when '＋'
        f1 + f2
      when 'ー'
        f1 - f2
      when '×'
        f1 * f2
      when '÷'
        f1 / f2

  # 全てをクリアする
  # allClear     :->
  #   @clear()
