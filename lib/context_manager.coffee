path = require 'path'
fs = require 'fs'

module.exports = class ContextManager

  # @param [Object] options The options object
  constructor: (@options) ->
    @current = undefined
    @useDefault(process.cwd())

  # Get the Tangle type (project, app, module, etc) of a directory
  useDefault: (dir) ->
    tangle = path.join dir, 'tangle.json'
    if fs.existsSync tangle
      config = JSON.parse(fs.readFileSync(tangle))
      @current = config.type

  # Get the subcommands matching a context
  getSubcommands: (context, commands) ->
    if context
      commands[context]?.subcommands
    else
      {}
