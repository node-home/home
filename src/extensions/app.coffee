home = require '../home'
app  = require '../core/app'

module.exports = home.extension 'app',
  name: "App"
  info: """
    An app is a pluggable module for home,
    with its own extensions.

    There is no inheritance, just composition.
  """
, app
