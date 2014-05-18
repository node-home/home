mongoose = require 'mongoose'
_        = require 'lodash'
home     = require '../home'

module.exports = home.extension 'model',
  name: 'Model'
  info: """
    A Light wrapper around mongoose models
  """
  params:
    schema:
      info: """
        A mongoose schema.
      """
      type: {}
    methods:
      info: """
        Model instance methods.
      """
      type: {}
    statics:
      info: """
        Model static methods.
      """
      type: {}
    virtuals:
      info: """
        Virtual 'constructed' attributes.
      """
      type: {}
    plugins:
      info: """
        Reusable bits of schema.
      """
      type: []
  , (name, options={}) ->
    schema = new mongoose.Schema options.schema

    singular = name.toLowerCase()
    plural = options.plural ? "#{name}s"

    _.defaults schema,
      app: @uid  #TODO ??

    _.defaults (options.virtuals ?= {}),
      plural: -> plural
      url: -> "#{@app ? ''}/#{plural}/#{@uid}"

    for option in ['methods', 'statics']
      schema[option][key] = val for key, val of options[option] || {}

    for key, val of options.virtuals ? {}
      val = get: val unless val.get? or val.set?
      virtual = schema.virtual key
      virtual.set val.set if val.set?
      virtual.get val.get if val.get?

    schema.plugin plugin for plugin in options.plugins || {}

    mongoose.model name, schema