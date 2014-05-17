module.exports = class App
  constructor: (@id) ->
    @dir = null
    @stylFile = null
    @clientFile = null
    @routes = []
    @lang = 'en'
    # Use these values, but don't change them. They're here for orchestrating.
    @root = '/'
    @static = '/s/'
