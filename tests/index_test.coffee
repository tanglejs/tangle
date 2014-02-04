nixt = require 'nixt'

itShouldShowHelp = ->
  it 'should mention the man page', (done) ->
    nixt()
      .run 'bin/tangle.coffee'
      .stdout /man tangle/
      .code 0
      .end done

  it 'should mention local subcommands', (done) ->
    nixt()
      .run 'bin/tangle.coffee'
      .stdout /--help/
      .code 0
      .end done

describe 'Running tangle', ->
  describe 'with no options', ->
    itShouldShowHelp()

  describe 'with --help', ->
    itShouldShowHelp()
