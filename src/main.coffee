require('coffee-script').register()
fs = require 'fs'
path = require 'path'
{Build} = require 'web-build-tools'

module.exports = ->
  try
    app = require path.resolve './manifest'
  catch e
    console.error "No `manifest.coffee` in current dir (#{path.resolve '.'})."
    process.exit 1
  build app

build = (app) ->
  runScript app, ->
    writeAppViews app, ->
      writeAppCss app, ->
        writeClientJs app, ->
          writeAppJs app, ->

runScript = (app, cb) ->
  app.useAppLogic = fs.existsSync 'app'
  Build.sh """
    rm -fr build
    mkdir -p build/s/css build/s/js
    if [ -f gulpfile.js ]; then
      gulp
    fi
    if [ -d app ]; then
      coffee --compile --bare --output build/app app
    fi
    if [ -d static ]; then
      cp -r static/* build/s
    fi
    """, cb

writeAppViews = (app, cb) ->
  Build.sh """
    # Copy Intercessor's views.
    cp -r #{__dirname}/../views build
    if [ -d views ]; then
      cp -r views/* build/views
    fi
  """, cb

writeAppJs = (app, cb) ->
  fs.writeFileSync 'build/app.js', """
    var Site = require('intercessor').Site;
    var app = #{JSON.stringify app};
    var site = new Site(app, __dirname);
    site.start(function () {});

  """
  cb()

writeAppCss = (app, cb) ->
  inFile = __dirname + '/../styles/index.styl'
  # Build Intercessor's styles.
  Build.stylus 'build/s/css/site.css', inFile, {}, ->
    appStyl = path.resolve 'styles/index.styl'
    return cb?() unless fs.existsSync appStyl
    app.useStylFile = true
    Build.stylus 'build/s/css/app.css', appStyl, {}, cb

writeClientJs = (app, cb) ->
  inFile = path.resolve 'client/index.coffee'
  return cb?() unless fs.existsSync inFile
  app.useClientFile = true
  Build.browserify 'build/s/js/client.js', inFile, {}, cb
