_ = require 'lodash'
_s = require 'underscore.string'

module.exports = (settings) ->
  config = settings.shell.settings.config
  styles = settings.shell.styles
  _.templateSettings.interpolate = /{([\s\S]+?)}/g

  template = '{context.type}:{context.name} [{environment}] >'

  getEnvironment = ->
    env = config.get 'environment'
    env = switch env
      when 'development' then styles.raw('dev', color: 'green')
      when 'test' then styles.raw('test', color: 'yellow')
      when 'production' then styles.raw('prod', color: 'red')
      else
        styles.raw(env, color: 'green')

  getContextName = ->
    name = config.get 'name'
    name = _s.truncate name, 10
    styles.raw name, color: 'magenta'

  getContextType = -> styles.raw('app', color: 'blue')

  setPrompt = ->
    prompt = _.template template,
      context:
        name: getContextName()
        type: getContextType()
      environment: getEnvironment()
    settings.shell.settings.prompt = prompt
    settings.shell._interface.setPrompt prompt, prompt.length
    settings.shell.prompt()

  setPrompt()
  (req, res, next) ->
    setPrompt()
    next()
