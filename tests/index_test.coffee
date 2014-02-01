nixt = require 'nixt'

itShouldShowHelp = ->
  it 'should mention the man page', (done) ->
    nixt()
      .run 'bin/tangle'
      .stdout /man tangle/
      .code 0
      .end done

  it 'should mention local subcommands', (done) ->
    nixt()
      .run 'bin/tangle'
      .stdout /--help/
      .code 0
      .end done

describe 'Running tangle', ->
  describe 'with no options', ->
    itShouldShowHelp()

  describe 'with --help', ->
    itShouldShowHelp()
