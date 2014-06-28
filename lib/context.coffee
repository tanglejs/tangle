path = require 'path'

module.exports = class Context
  # @param [Object] options The options object
  constructor: (options) ->
    @name = options.name || path.basename(process.cwd())
    @type = options.type || 'global'

  # Get the subcommands matching a context
  getSubcommands: (commands) ->
    commands[@type]?.subcommands
