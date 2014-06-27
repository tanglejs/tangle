#!/usr/bin/env coffee

shell = require 'shell'
path = require 'path'

context = require path.join(__dirname, 'lib', 'context')
prompt = require path.join(__dirname, 'lib', 'prompt')

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
  app.use prompt shell: app
  app.use context.router shell: app
  app.use shell.router shell: app
  app.use context.completer shell: app
  app.use shell.history shell: app
  app.use shell.help shell: app, introduction: true

app.settings.loader.mount app

# TODO - Fuzzy match on command set (for abbrev support)
# TODO - Bash/Zsh completions
# TODO - Help text
