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
    }
    eq false, figure.isNew()

  it '1→2', ->
    figure = new Figure(value:1)
    figure.addDigit 2

    ok figure.isValid()
    modelEq figure, {
      value : 12
    }
    eq false, figure.isNew()

  it '1.→2', ->
    figure = new Figure(value:1, dot:true)
    figure.addDigit 2

    ok figure.isValid()
    modelEq figure, {
      dot         :true
      decimalPoint:1
      value       : 1.2
    }
    eq false, figure.isNew()

  it '.→2', ->
    figure = new Figure(dot:true)
    figure.addDigit 2

    ok figure.isValid()
    modelEq figure, {
      dot         :true
      decimalPoint:1
      value       : 0.2
    }
    eq false, figure.isNew()

  it '.→2→3', ->
    figure = new Figure(dot:true)
    figure.addDigit 2
    figure.dot()
    figure.addDigit 3

    ok figure.isValid()
    modelEq figure, {
      dot         :true
      decimalPoint:2
      value       : 0.23
    }
    eq false, figure.isNew()


describe '文字列入力のテスト', ->

  it '空→1', ->
    figure = new Figure
    figure.addDigit '1'
    ok figure.isValid()
    modelEq figure, {
      value : 1
    }
    eq false, figure.isNew()

  it '1→2', ->
    figure = new Figure(value:1)
    figure.addDigit '2'

    ok figure.isValid()
    modelEq figure, {
      value : 12
    }
    eq false, figure.isNew()

  it '1.→2', ->
    figure = new Figure(value:1, dot:true)
    figure.addDigit '2'

    ok figure.isValid()
    modelEq figure, {
      dot         :true
      decimalPoint:1
      value       : 1.2
    }
    eq false, figure.isNew()

  it '.→2', ->
    figure = new Figure(dot:true)
    figure.addDigit '2'

    ok figure.isValid()
    modelEq figure, {
      dot         :true
      decimalPoint:1
      value       : 0.2
    }
    eq false, figure.isNew()

  it '.→2→3', ->
    figure = new Figure(dot:true)
    figure.addDigit '2'
    figure.dot()
    figure.addDigit '3'

    ok figure.isValid()
    modelEq figure, {
      dot         :true
      decimalPoint:2
      value       : 0.23
    }
    eq false, figure.isNew()

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
