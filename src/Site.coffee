express = require 'express'
http = require 'http'
path = require 'path'

module.exports = class Site
  constructor: (@app, @appDir) ->
    @express = null
    @server = null
    @appLogic = null
    @port = 3000

  start: (cb) ->
    @express = express()
    @configure()
    @registerRoutes()
    @createServer cb

  stop: ->

  configure: ->
    e = @express

    e.set 'port', @port
    e.set 'views', @appDir + '/views'
    e.set 'view engine', 'jade'

    e.use express.favicon()
    e.use express.urlencoded()
    e.use express.json()
    e.use express.methodOverride()
    e.use '/s', express.static @appDir + '/s'
    e.use @locals.bind this
    e.use e.router

  registerRoutes: ->
    return unless @app.useAppLogic
    @appLogic = require path.resolve @appDir + '/app/index'

    for route in @app.routes
      [verb, path, funcName] = route
      @express[verb] path, @appLogic.routes[funcName]
    return

  createServer: (cb) ->
    @server = http.createServer @express
    @server.listen @port, =>
      console.log 'standalone', @app.id, 'server listening on', @port
      cb()

  locals: (req, res, next) ->
    res.locals.app = @app
    next()
