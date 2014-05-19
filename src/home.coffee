core = require './core'

module.exports = home = core.app module,
  name: 'Home'
  url: ''  #'//home.local' || settings.HOST
  info: """
    The god object.

    Everything within the home system
    is available through this object.

    All extensions and plugins are discoverable by hateoas.
  """
  , (app) ->
    app.endpoint = (args...) ->
      endpoint = core.endpoint args...
      app.bus.emit 'endpoint', endpoint.options.method, endpoint.options.url, endpoint
      app.bus.emit 'manifest', endpoint.options.url, -> core.manifest app
      endpoint

    core.manifest app.url, app

home.extension 'app',
  name: "App"
  info: """
    An app is a pluggable module for home,
    with its own extensions.

    There is no inheritance, just composition.
  """
, core.app
