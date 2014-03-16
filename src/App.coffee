class App
  constructor: (@id) ->
    @dir = null
    @stylFile = null
    @clientFile = null
    @routes = []
    @lang = 'en'
    # Use this value, but don't change it. It's here for orchestrating.
    @root = '/'

module.exports = App
