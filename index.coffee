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

app.settings.logger.cli()
app.settings.loader.loadAll /^tangle.*$/
app.settings.contextManager = new ContextManager shell: app

app.configure ->
  app.use prompt shell: app
  app.use app.settings.contextManager.rewriteRouter shell: app
  app.use shell.router shell: app
  app.use app.settings.contextManager.rewriteCompleter shell: app
  app.use shell.history shell: app
  app.use shell.help shell: app, introduction: true

app.settings.loader.mount app

if app.isShell then readlineHack app

# TODO - Fuzzy match on command set (for abbrev support)
# TODO - Bash/Zsh completions
# TODO - Help text
