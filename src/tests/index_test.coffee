nixt = require 'nixt'
path = require 'path'

showHelp = (result) ->
  if !(result.stdout.match(/man tangle/))
    return new Error('Extra help should be mentioned')
  if !(result.stdout.match(/--help/))
    return new Error('Local subcommands should be mentioned')

exports.group =

  'No options': (test) ->
    test.doesNotThrow ->
      nixt()
        .expect(showHelp)
        .run('bin/tangle')
        .code(0)
        .end(test.done)

  '--help': (test) ->
    test.doesNotThrow ->
      nixt()
        .expect(showHelp)
        .run('bin/tangle --help')
        .code(0)
        .end(test.done)
