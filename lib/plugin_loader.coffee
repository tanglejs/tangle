_ = require 'lodash'
Plugin = require './plugin'
CLIFormatter = require './formatters/cli'
path = require 'path'
chdir = require 'chdir'

module.exports = class PluginLoader

  # Search the dependecies in order to find application plugins matching the
  # provided filter.
  #
  # @param [RegExp] filter Expression matching the names of the modules
  loadAll: (filter) ->
    chdir path.join(__dirname, '..'), =>
      finder = require 'plugin-finder'
      @plugins = _.map finder.loadAll(filter), (pluginModule) ->
        new Plugin pluginModule
  
  # @option options [shell] shell A node-shell instance to mount plugins on
  mount: (shell) ->
    _.each @_mapRoutes(), (options, command) =>
      @_addSubcommands('', command, options, shell)
  
  # @private
  _mapRoutes: ->
    routes = {}
    _.each @plugins, (plugin) ->
      # TODO - Use a proper deep merge
      _.merge routes, plugin.getCommands()
    routes

  # @private
  _addSubcommands: (prefix, command, options, shell) ->
    route = prefix + command
    if options.action
      shell.cmd route, options.description, (req, res) ->

        if options.defaults?
          params = _.clone(options.defaults)
          _.defaults params, req.params
        else
          params = req.params

        formatter = new CLIFormatter
        options.action(params, shell)(shell.settings.config)
          .progress (data) -> formatter.progress res, data
          .then (data) -> formatter.then res, data
          .fail (data) -> formatter.fail res, data
          .finally -> res.prompt() if req.shell.isShell

    if options.subcommands
      _.each options.subcommands, (subcommandOptions, subcommand) =>
        @_addSubcommands route + ' ', subcommand, subcommandOptions, shell
