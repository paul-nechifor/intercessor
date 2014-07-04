require('coffee-script').register()
fs = require 'fs'
path = require 'path'
{Build} = require 'web-build-tools'

module.exports = class Intercessor
  constructor: (@projectPath, @buildPath) ->
    @standalone = true
    @app = null
    @manifest = null
    @src = {}
    @dst = {}

  makeAppInfo: (cb) ->
    @readManifest (err) =>
      return cb err if err
      @setDefaultValues()
      @buildTransformations()
      cb()

  build: (cb) ->
    @makeAppInfo (err) =>
      return cb err if err
      @runTasks (err) ->
        return cb err if err
        cb()

  readManifest: (cb) ->
    try
      @app = require path.resolve @projectPath + '/intercessor'
    catch e
      return cb 'not-intercessor-project'
    cb()

  setDefaultValues: ->
    @app.id or= 'app'
    @app.title or= 'App'
    @app.lang or= 'en'

  buildTransformations: ->
    @src.project = @projectPath
    @dst.project = @buildPath

    # Choose one or the other based on wether it's a standalone project or not.
    o = (a, b) => if @standalone then a else b
    # Append the path if it isn't standalone.
    append = (a) => if @standalone then a else a + '/' + @app.id
    # Set relative src and dst values.
    srcDst = (key, a, b) =>
      @src[key] = @src.project + a
      @dst[key] = @dst.project + b

    @app.paths =
      globalStatic: '/s'
      static: append '/s'
      client: o '/s/js/client.js', "/s/js/#{@app.id}/client.js"
      style: o '/s/css/app.css', "/s/css/#{@app.id}/app.css"

    fileDirSet = (key, srcOrDst, value) =>
      @[srcOrDst][key + 'File'] = @[srcOrDst].project + value
      @[srcOrDst][key] = path.dirname @[srcOrDst][key + 'File']

    srcDst 'static', '/static', @app.paths.static
    srcDst 'views', '/views', '/views/' + @app.id
    srcDst 'app', '/app', append '/app'
    srcDst 'html', '/html', append '/html'

    fileDirSet 'client', 'src', '/client/index.coffee'
    fileDirSet 'client', 'dst', @app.paths.client
    fileDirSet 'style', 'src', '/styles/index.styl'
    fileDirSet 'style', 'dst', @app.paths.style

  runTasks: (cb) ->
    tasks = [
      @runGulp
      @makeBuildDir
      @copyOrMakeStatic
      @makeApp
      @copyHtml
      @copyViews
      @makeClientJs
      @makeStyles
      @makeAppJs
    ].map (f) => f.bind @

    i = 0
    next = ->
      return cb null if i >= tasks.length
      tasks[i] (err) ->
        return cb err if err
        i++
        next()
    next()

  runGulp: (cb) ->
    Build.sh """
      cd '#{@src.project}'
      if [ -f gulpfile.js ]; then
        gulp --app #{JSON.stringify JSON.stringify @app}
      fi
    """, cb

  makeBuildDir: (cb) ->
    return cb null unless @standalone
    Build.sh """
      rm -fr '#{@dst.project}'
      mkdir -p '#{@dst.project}'
    """, cb

  copyOrMakeStatic: (cb) ->
    Build.sh """
      mkdir -p '#{@dst.static}' 2> /dev/null
      if [ -d '#{@src.static}' ]; then
        cp -r '#{@src.static}'/* '#{@dst.static}'
      fi
    """, cb

  makeApp: (cb) ->
    @app.useAppLogic = fs.existsSync @src.app
    return cb null unless @app.useAppLogic
    Build.sh """
      coffee --compile --bare --output '#{@dst.app}' '#{@src.app}'
    """, cb

  copyHtml: (cb) ->
    @app.useHtml = fs.existsSync @src.html
    return cb null unless @app.useHtml
    Build.sh """
      cp -r '#{@src.html}' '#{@dst.html}'
    """, cb

  copyViews: (cb) ->
    fs.readdir @src.views, (err, files) =>
      return cb null if err # Ignore errors.
      @app.views = {}
      for file in files
        key = file.substring 0, file.length - 5
        @app.views[key] = @app.id + '/' + key

      exec = "mkdir -p '#{@dst.views}'\n"
      exec += """
        cp -r '#{__dirname + '/../views'}'/* '#{@dst.project}'/views
      """ if @standalone
      exec += """\n
        cp -r '#{@src.views}'/* '#{@dst.views}'/
      """
      Build.sh exec, cb

  makeClientJs: (cb) ->
    inFile = path.resolve @src.clientFile
    return cb null unless fs.existsSync inFile
    @app.useClientFile = true
    @makeDir @dst.client, cb, =>
      Build.browserify @dst.clientFile, inFile, {}, cb

  makeStyles: (cb) ->
    opts =
      defines:
        appPathsStatic: @app.paths.static
        appPathsGlobalStatic: @app.paths.globalStatic
    makeSiteStyle = (cb) =>
      return cb null unless @standalone
      inFile = __dirname + '/../styles/index.styl'
      @makeDir "#{@buildPath}/s/css", cb, =>
        Build.stylus "#{@buildPath}/s/css/site.css", inFile, opts, cb
    makeOwnStyle = (cb) =>
      appStyl = path.resolve @src.styleFile
      return cb() unless fs.existsSync appStyl
      @app.useStylFile = true
      @makeDir @dst.style, cb, =>
        Build.stylus @dst.styleFile, appStyl, opts, cb
    makeSiteStyle (err) ->
      return cb err if err
      makeOwnStyle cb

  makeAppJs: (cb) ->
    return cb null unless @standalone
    fs.writeFileSync @dst.project + '/app.js', """
      var Site = require('intercessor').Site;
      var app = #{JSON.stringify @app};
      var site = new Site(app, __dirname);
      site.start(function () {});
    """
    cb()

  makeDir: (dir, badCb, goodCb) ->
    Build.sh "mkdir -p '#{dir}' 2>/dev/null", (err) ->
      return badCb err if err
      goodCb()
