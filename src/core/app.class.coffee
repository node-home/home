_        = require 'lodash'
events   = require 'events'
path     = require 'path'

endpoint = require './endpoint'

###
Reponsibilities
- Provide a base to put extensions on
- Load Extensions on init
- Provide a base url for an app
- Provide the manifest for the base url
###
class App extends events.EventEmitter
  constructor: (@module, @options={}) ->
    # TODO load package.json
    try
      pkg = @module.require path.join path.dirname(@module.id), '..', 'package'
    catch
      try
        pkg = @module.require path.join path.dirname(@module.id), 'package'
      catch
        [parts..., ext] = @module.filename.split '.'
        pkg =
          uid: parts.join '.'

    _.defaults @options,
      uid: pkg.name
      info: pkg.description
      version: pkg.version

    @uid = @options.uid

    @extensions = {}

  ###
   * TODO find and load all extensions
  ###
  init: ->
    # console.log "Welcome #{@options.name}"

    console.log 'require', path.join path.dirname(@module.id), 'extensions'
    @module.require path.join path.dirname(@module.id), 'extensions'

    console.log "init", @uid

    for cls, extension of @extensions
      console.log "init", "#{@uid}.#{cls}", !!extension.init
      extension.init?()

      for obj, object of @[extension.plural]
        console.log "init", "#{@uid}.#{cls}.#{obj}"
        object.init?()

    delete @module

  ###
   * The preferred way of loading home modules
  ###
  require: (app_uid) ->
    # TODO the magic to find the modules
    require "#{@uid}.#{app_uid}"

  ###
   * Attach a factory to the calling app's prototype.
   *
   * The extension has factory method and an optional init.
   * Objects created by the factory are stored in a container on the
   * calling app instance.
  ###
  extension: (singular, options, factory=endpoint) ->
    console.log 'extension', singular

    options ?= {}
    plural  = options.plural ?= "#{singular}s"
    url     = options.url    ?= "#{@options.url}/#{plural}"

    # The container that holds the options of an app's extension
    @extensions[singular] = options

    # The container that holds the extension's constructed objects
    @[plural] = {}

    theExtension = (uid, args...) =>
      # We'll do some filthy magic here
      # Sometimes we want to pass in a module in stead of a uid
      # In that case, the uid becomes the module name
      if uid.id
        name = path.basename uid.id, path.extname uid.id
        name = path.basename path.dirname uid.id if name is 'index'
      else
        name = uid

      console.log 'theExtension', plural, name
      @[plural][name] = factory.call @, uid, args...

    # The factory method exposed
    @[singular] = theExtension
    theExtension.options = options
    theExtension

module.exports = App
