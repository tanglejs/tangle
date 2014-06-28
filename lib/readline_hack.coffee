# With a colorized prompt, tab completion causes the cursor to be positioned
# incorrectly (one row high) in terminals without enough columns to display
# the completions without wrapping.

_ = require 'lodash'
module.exports = (app) ->
  original = _.bind app._interface._tabComplete, app._interface
  app._interface._tabComplete = ->
    original()
    app._interface.output.moveCursor 0, 1
