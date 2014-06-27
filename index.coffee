#!/usr/bin/env coffee

shell = require 'shell'
context = require './lib/context'

PluginLoader = require './lib/plugin_loader'
ContextManager = require './lib/context_manager'

app = new shell
  prompt: 'tangle>'
  config: require('tangle-config').load()
  logger: require 'winston'
  loader: new PluginLoader
  contextManager: new ContextManager

app.settings.logger.cli()
app.settings.loader.loadAll /^tangle.*$/

app.configure ->
  app.use context.router shell: app
  app.use shell.router shell: app
  app.use shell.history shell: app
  app.use context.completer shell: app
  app.use shell.help shell: app, introduction: true

app.settings.loader.mount app

# TODO - Fuzzy match on command set (for abbrev support)
# TODO - Bash/Zsh completions
# TODO - Help text
