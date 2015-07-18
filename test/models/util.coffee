_   = require 'underscore'
eq  = (require 'assert').deepEqual

# modelのアサーションユーティリティ
module.exports = {
  modelEq : (model, update) ->
    clone = _.clone model.defaults
    eq model.toJSON(), _.extend clone, update  
}
