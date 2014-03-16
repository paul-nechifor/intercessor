require('coffee-script').register()
path = require 'path'
Build = require('web-build-tools').Build
fs = require 'fs'

main = ->
  try
    app = require path.resolve './app'
  catch e
    console.error "Found no `app` in current dir (#{path.resolve '.'})."
    process.exit 1
  build app

build = (app) ->
  runScript app, ->
    writeAppJs()
    writeCss app
    writeClient app

runScript = (app, cb) ->
  Build.sh """
      rm -fr build
      mkdir build
      coffee --compile --bare --output build/app app
      cp -r #{__dirname}/../views build
      cp -r views/* build/views
      mkdir -p build/s/css build/s/js
    """, cb

writeAppJs = ->
  fs.writeFileSync 'build/app.js', """
    var app = require('./app/index');
    var Site = require('intercessor').Site;

    var site = new Site(app);
    site.start(function () {});

  """

writeCss = (app, cb) ->
  inFile = __dirname + '/../styles/index.styl'
  Build.stylus 'build/s/css/site.css', inFile, {}, ->
    return cb?() if not app.stylFile
    Build.stylus 'build/s/css/app.css', app.stylFile, {}, cb

writeClient = (app, cb) ->
  return cb?() if not app.clientFile
  inFile = path.resolve app.clientFile
  Build.browserify 'build/s/js/client.js', inFile, {}, cb

module.exports = main
