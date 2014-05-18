###
 * Somehow this should provide a persistent customizable
 * configuration with default fallbacks.
###
mongoose = require 'mongoose'
home     = require '../home'

schema = mongoose.Schema
  app:
    type: String
    required: yes
  settings:
    type: {}

module.exports = mongoose.model schema

home.extension 'config',
  name: "Config"
  info: """
    Database store for app settings.
  """
  , ({schema}) ->
    @model {schema}
