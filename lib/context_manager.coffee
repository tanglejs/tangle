path = require 'path'
_ = require 'lodash'
parse = require('shell-quote').parse
Context = require path.join(__dirname, 'context')

module.exports = class ContextManager

  # @param [Object] options The options object
  constructor: (@options) ->
    @config = @options.shell.settings.config
    @current = new Context
      type: @config.get 'type'
      name: @config.get 'name'

  # Enable this middleware to allow the parent of a subcommand to be omitted
  # if the parent is equal to the current context.
  rewriteRouter: (settings) ->
    (req, res, next) =>
      shell = settings.shell
      loader = shell.settings.loader
      commands = loader._mapRoutes()

      if @current
        parts = parse _.clone(req.command)
        unless _.contains(_.keys(commands), parts[0])
          if _.contains(_.keys(@current.getSubcommands(commands)), parts[0])
            parts.unshift @current.type
            req.command = parts.join ' '
      next()

  # Enable this middleware to add completion suggestions for subcommands
  # of the current context.
  rewriteCompleter: (settings) ->
    # Validation
    throw new Error 'No shell provided' if not settings.shell
    shell = settings.shell
    # Plug completer to interface
    return unless shell.isShell
    shell.interface().completer = (text, cb) =>
      suggestions = []

      # Get suggestions from router
      routes = shell.routes
      for route in routes
        command = route.command
        if command.substr(0, text.length) is text
          suggestions.push command

      # Get suggestions from context
      loader = shell.settings.loader
      subcommands = _.keys(@current.getSubcommands(loader._mapRoutes()))

      for command in subcommands
        if command.substr(0, text.length) is text
          suggestions.push command

      cb(false, [suggestions, text])
    null
