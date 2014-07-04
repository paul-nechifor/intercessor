optimist = require 'optimist'
path = require 'path'
Intercessor = require './Intercessor'

module.exports = main = ->
  argv = optimist
  .usage 'Usage: $0'

  .default 'p', path.resolve '.'
  .alias 'p', 'project-dir'
  .describe 'p', 'The location of the project (contains `intercessor.coffee`).'

  .default 'b', path.resolve './build'
  .alias 'b', 'build-dir'
  .describe 'b', 'Where to build the project.'

  .alias 'h', 'help'
  .describe 'h', 'Print this help message.'
  .argv

  if argv.h
    optimist.showHelp()
    process.exit()

  intercessor = new Intercessor argv['project-dir'], argv['build-dir']
  intercessor.build (err) ->
    if err
      console.log err
      process.exit 1
