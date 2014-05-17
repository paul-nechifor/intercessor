express = require 'express'
http = require 'http'

module.exports = class Site
  constructor: (@app) ->
    @express = null
    @server = null
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
    e.set 'views', @app.dir + '/views'
    e.set 'view engine', 'jade'

    e.use express.favicon()
    e.use express.urlencoded()
    e.use express.json()
    e.use express.methodOverride()
    e.use '/s', express.static @app.dir + '/s'
    e.use @locals.bind this
    e.use e.router

  registerRoutes: ->
    for route in @app.routes
      [verb, path, func] = route
      @express[verb] path, func
    return

  createServer: (cb) ->
    @server = http.createServer @express
    @server.listen @port, =>
      console.log 'standalone', @app.id, 'server listening on', @port
      cb()

  locals: (req, res, next) ->
    res.locals.app = @app
    next()
