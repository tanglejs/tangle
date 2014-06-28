path = require 'path'
fs = require 'fs'
_ = require 'lodash'
parse = require('shell-quote').parse

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

  # Enable this middleware to allow the parent of a subcommand to be omitted
  # if the parent is equal to the current context.
  rewriteRouter: (settings) ->
    (req, res, next) ->
      shell = settings.shell
      loader = shell.settings.loader
      commands = loader._mapRoutes()
      contextManager = shell.settings.contextManager

      if context = contextManager.current
        parts = parse _.clone(req.command)
        unless _.contains(_.keys(commands), parts[0])
          if _.contains(_.keys(contextManager.getSubcommands(context, commands)), parts[0])
            parts.unshift context
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
    shell.interface().completer = (text, cb) ->
      suggestions = []

      # Get suggestions from router
      routes = shell.routes
      for route in routes
        command = route.command
        if command.substr(0, text.length) is text
          suggestions.push command

      # Get suggestions from context
      loader = shell.settings.loader
      contextManager = shell.settings.contextManager
      context = contextManager.current
      subcommands = _.keys(contextManager.getSubcommands(context, loader._mapRoutes()))

      for command in subcommands
        if command.substr(0, text.length) is text
          suggestions.push command

      #shell.interface().moveCursor process.stdout, 10, 10

      cb(false, [suggestions, text])
    null
