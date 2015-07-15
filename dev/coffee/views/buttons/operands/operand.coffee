Events = require '../../..//events/event'
Button = require '../button.coffee'

module.exports = Button.extend

  className : 'operand'

  click : ->
    Events.trigger 'click:operand', @id
