#!/usr/bin/env coffee

shell = require 'shell'
path = require 'path'

prompt = require path.join(__dirname, 'lib', 'prompt')
readlineHack = require path.join(__dirname, 'lib', 'readline_hack')

PluginLoader = require './lib/plugin_loader'
ContextManager = require './lib/context_manager'

app = new shell
  config: require('tangle-config').load()
  logger: require 'winston'
  loader: new PluginLoader
  contextManager: new ContextManager

app.settings.logger.cli()
app.settings.loader.loadAll /^tangle.*$/

app.configure ->
  app.use app.settings.contextManager.rewriteRouter shell: app
  app.use shell.router shell: app
  app.use app.settings.contextManager.rewriteCompleter shell: app
  app.use shell.history shell: app
  app.use shell.help shell: app, introduction: true
  app.use prompt shell: app

app.settings.loader.mount app

readlineHack app

# TODO - Fuzzy match on command set (for abbrev support)
# TODO - Bash/Zsh completions
# TODO - Help text
