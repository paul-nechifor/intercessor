{exec} = require 'child_process'

task 'build', 'Build the Node package.', ->
  cmd = 'rm lib/* 2>/dev/null; coffee --compile --bare --output lib src'
  exec cmd, (err, stdout, stderr) ->
    throw err if err
    process.stdout.write stdout + stderr
    cb?()
