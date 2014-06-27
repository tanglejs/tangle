_ = require 'lodash'
parse = require('shell-quote').parse

router = (settings) ->
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

completer = (settings) ->
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

    cb(false, [suggestions, text])
  null

module.exports =
  router: router
  completer: completer
