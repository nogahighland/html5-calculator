eq      = (require 'assert').equal
modelEq = (require './util.coffee').modelEq
Figuer  = require '../../dev/coffee/models/figure'
App     = require '../../dev/coffee/models/app'

plus     = '＋'
minus    = 'ー'
multiply = '×'
devide   = '÷'
equal    = '＝'
clear    = 'C'

describe 'シナリオ', () ->
  it 'test1', () ->
    app = new App
    app.updateFigure 2

    f1 = app.get 'operand1'
    f2 = app.get 'operand2'
    r  = app.get 'result'

    modelEq f1, {
      isNew : false
      value : 2
    }
    modelEq f2, {}
    modelEq r, {}
    eq 2, app.get 'display'

  it 'test2', () ->
    app = new App
    app.updateFigure 2
    app.updateFigure 3

    f1 = app.get 'operand1'
    f2 = app.get 'operand2'
    r  = app.get 'result'

    modelEq f1, {
      isNew : false
      value : 23
    }
    modelEq f2, {}
    modelEq r, {}
    eq 23, app.get 'display'

  it 'test3', () ->
    app = new App
    app.updateFigure 2
    app.updateFigure 3
    app.updateOperator plus

    f1 = app.get 'operand1'
    f2 = app.get 'operand2'
    r  = app.get 'result'

    modelEq f1, {
      isNew  : false
      value  : 23
      operator:plus
    }
    modelEq f2, {}
    modelEq r, {}
    eq 23, app.get 'display'

  it 'test4', () ->
    app = new App
    app.updateFigure 2
    app.updateFigure 3
    app.updateOperator plus
    app.updateFigure 4

    f1 = app.get 'operand1'
    f2 = app.get 'operand2'
    r  = app.get 'result'

    modelEq f1, {
      isNew  : false
      value  : 23
      operator:plus
    }
    modelEq f2, {
      isNew : false
      value : 4
    }
    modelEq r, {}
    eq 4, app.get 'display'

  it 'test5', () ->
    app = new App
    app.updateFigure 2
    app.updateFigure 3
    app.updateOperator plus
    app.updateFigure 4
    app.updateOperator equal

    f1 = app.get 'operand1'
    f2 = app.get 'operand2'
    r  = app.get 'result'

    modelEq f1, {}
    modelEq f2, {}
    eq 27, app.get 'display'

  it 'test6', () ->
    app = new App
    app.updateFigure 2
    app.updateFigure 3
    app.updateOperator plus
    app.updateFigure 4
    app.updateOperator equal
    app.updateOperator plus
    app.updateFigure 9
    app.updateOperator equal

    f1 = app.get 'operand1'
    f2 = app.get 'operand2'
    r  = app.get 'result'

    modelEq f1, {}
    modelEq f2, {}
    eq 36, app.get 'display'
