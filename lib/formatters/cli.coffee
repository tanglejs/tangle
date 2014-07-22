pretty = require 'prettyjson'

module.exports = class CLIFormatter
  constructor: ->

  progress: (res, data) ->
    res.println pretty.render data

  then: (res, data) ->
    res.println pretty.render data

  fail: (res, data) ->
    res.red(data).ln()
