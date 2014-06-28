# With a colorized prompt, tab completion causes the cursor to be positioned
# incorrectly. This workaround removes the prompt style during completion.

_ = require 'lodash'
styles = require 'shell/lib/Styles'

module.exports = (app) ->
  original = _.bind app._interface._tabComplete, app._interface
  app._interface._tabComplete = ->
    app._interface._prompt = styles.unstyle(app._interface._prompt)
    original()
