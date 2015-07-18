modelEq  = (require './util.coffee').modelEq
ok = (require 'assert').ok
eq = (require 'assert').equal
Figure = require '../../dev/coffee/models/figure'


describe '数字入力のテスト', ->

  it '空→1', ->
    figure = new Figure
    figure.addDigit 1
    ok figure.isValid()
    modelEq figure, {
      value : 1
      isNew :false
    }

  it '1→2', ->
    figure = new Figure(value:1)
    figure.addDigit 2

    ok figure.isValid()
    modelEq figure, {
      value : 12
      isNew :false
    }

  it '1.→2', ->
    figure = new Figure(value:1, dot:true, decimalPoint:1)
    figure.addDigit 2

    ok figure.isValid()
    modelEq figure, {
      dot         :true
      decimalPoint:2
      value       : 1.2
      isNew       :false
    }

  it '.→2', ->
    figure = new Figure(dot:true, decimalPoint:1)
    figure.addDigit 2

    ok figure.isValid()
    modelEq figure, {
      dot         :true
      decimalPoint:2
      value       : 0.2
      isNew       :false
    }

  it '.→2→3', ->
    figure = new Figure(dot:true, decimalPoint:1)
    figure.addDigit 2
    figure.dot()
    figure.addDigit 3

    ok figure.isValid()
    modelEq figure, {
      dot         :true
      decimalPoint:3
      value       : 0.23
      isNew       :false
    }

  it '0.1111111111→1', ->
    figure = new Figure(value:0.1111111111, decimalPoint:11, dot:true)
    figure.addDigit 1
    eq 0.11111111111, figure.get 'value'

describe '文字列入力のテスト', ->

  it '空→1', ->
    figure = new Figure
    figure.addDigit '1'
    ok figure.isValid()
    modelEq figure, {
      value : 1
      isNew :false
    }

  it '1→2', ->
    figure = new Figure(value:1)
    figure.addDigit '2'

    ok figure.isValid()
    modelEq figure, {
      value : 12
      isNew :false
    }

  it '1.→2', ->
    figure = new Figure(value:1, dot:true, decimalPoint:1)
    figure.addDigit '2'

    ok figure.isValid()
    modelEq figure, {
      dot         : true
      decimalPoint: 2
      value       : 1.2
      isNew       :false
    }

  it '.→2', ->
    figure = new Figure(dot:true, decimalPoint:1)
    figure.addDigit '2'

    ok figure.isValid()
    modelEq figure, {
      dot         : true
      decimalPoint: 2
      value       : 0.2
      isNew       :false
    }

  it '.→2→3', ->
    figure = new Figure(dot:true,decimalPoint:1)
    figure.addDigit '2'
    figure.dot()
    figure.addDigit '3'

    ok figure.isValid()
    modelEq figure, {
      dot         : true
      decimalPoint: 3
      value       : 0.23
      isNew       :false
    }

describe '削除のテスト', ->

  it '値無し', ->
    figure = new Figure
    figure.delete()
    eq 0, figure.get 'value'

  it '123→12', ->
    figure = new Figure(value:123)
    figure.delete()
    eq 12, figure.get 'value'

  it '12.3→12', ->
    figure = new Figure(value:123)
    figure.delete()
    eq 12, figure.get 'value'

  it '12.3→12', ->
    figure = new Figure(value:123)
    figure.delete()
    eq 12, figure.get 'value'

describe '異常値', ->
  it 'Infinite', ->
    figure = new Figure
    figure.set 'value', Infinity

    eq false, figure.isValid()
    eq 'value is Infinite', figure.validationError

  it 'NaN', ->
    figure = new Figure
    figure.set 'value', NaN

    eq false, figure.isValid()
    eq 'value is NaN', figure.validationError

  it '数字じゃない(NaN以外)', ->
    figure = new Figure
    figure.set 'value', 'aaa'

    eq false, figure.isValid()
    eq 'aaa is not a number', figure.validationError

describe '計算', ->
  it '足し算', ->
    f1 = new Figure(value:1)
    f2 = new Figure(value:2)
    expect = new Figure(value:3, firstFigure:f1, secondFigure:f2, operand:'＋')
    modelEq expect, f1.plus(f2).toJSON()

  it '引き算', ->
    f1 = new Figure(value:1)
    f2 = new Figure(value:2)
    expect = new Figure(value:-1, firstFigure:f1, secondFigure:f2, operand:'ー')
    modelEq expect, f1.minus(f2).toJSON()

  it '掛け算', ->
    f1 = new Figure(value:10)
    f2 = new Figure(value:2)
    expect = new Figure(value:20, firstFigure:f1, secondFigure:f2, operand:'×')
    modelEq expect, f1.multiply(f2).toJSON()

  it '割り算(10/2)', ->
    f1 = new Figure(value:10)
    f2 = new Figure(value:2)
    expect = new Figure(value:5, firstFigure:f1, secondFigure:f2, operand:'÷')
    modelEq expect, f1.devide(f2).toJSON()

  it '割り算(2/10)', ->
    f1 = new Figure(value:2)
    f2 = new Figure(value:10)
    expect = new Figure(value:0.2, firstFigure:f1, secondFigure:f2, operand:'÷', decimalPoint:2, dot:true)
    modelEq expect, f1.devide(f2).toJSON()

  it '反転', ->
    figure = new Figure(value:10)
    figure.invert()

    eq -10, figure.get('value')

describe 'シナリオテスト', ->
  it '1→2→3→.→4→反転→削除→5', ->
    figure = new Figure
    figure.addDigit 1
    figure.addDigit 2
    figure.addDigit 3
    # 123
    figure.dot()
    figure.addDigit 4
    # 123.4
    figure.invert()
    # -123.4
    figure.delete()
    # -123
    figure.addDigit 5
    # -122.5

    modelEq figure, {
      decimalPoint: 2
      dot         : true
      value       : -122.5
      isNew       :false
    }

describe 'コンストラクタ', ->
  it '123', ->
    figure = new Figure value:123
    modelEq figure, {
      value : 123
    }

  it '123.456', ->
    figure = new Figure value:123.456
    modelEq figure, {
      dot         : true
      decimalPoint: 4
      value       : 123.456
    }
    figure.addDigit 7
    modelEq figure, {
      isNew       : false
      dot         : true
      decimalPoint: 5
      value       : 123.4567
    }
