require 'coffee-script/register'
helmsman = require 'helmsman'

cli = helmsman
  localDir: 'bin'
  prefix: 'tangle'
  usePath: true

cli.on '--help', ->
  console.log "\ntangle - wire up your frontends using grunt & marionette"
  console.log "\nFor detailed usage, view \"man tangle\"."

argv = process.argv

cli.parse(argv)
