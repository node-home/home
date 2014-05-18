app = require './core/app'

module.exports = home = app module,
  name: 'Home'
  url: ''  #'//home.local' || settings.HOST
  info: """
    The god object.

    Everything within the home system
    is available through this object.

    All extensions and plugins are discoverable by hateoas.
  """

home.extension 'app',
  name: "App"
  info: """
    An app is a pluggable module for home,
    with its own extensions.

    There is no inheritance, just composition.
  """
, app
