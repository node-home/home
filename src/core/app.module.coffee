_        = require 'lodash'
events   = require 'events'
path     = require 'path'

endpoint = require './endpoint'

###
Extract the name based on a module's filename
###
moduleName = (module) ->
  return module if module is "#{module}"
  name = path.basename module.id, path.extname module.id
  name = path.basename path.dirname module.id if name is 'index'
  name

###
Find or construct a package for given module
###
modulePackage = (module) ->
  dir = module.id

  # TODO maybe just look at adjacent packages
  for dir in module.paths
    try
      return module.require path.join dir, 'package'
    catch
      continue

  name: moduleName module

###
An app is basically a decorated module/package.
Home tries to abolish classes and encourage composition.
This is the biggest effort towards that
###
module.exports = (module, pkg={}, setup=(->)) ->
  pojo =
    package: _.defaults pkg, modulePackage module
    factories: {}
    products: {}
    extensions: {}

  pojo.init = ->
    try
      module.require './extensions'
    catch error
      console.log "LOAD EXTENSIONS ERROR", pojo.package.name, error

    # try
    #   console.log "Loaded extensions"
    # catch error
    #   console.log "No extensions", error
    setup? pojo

    for fac, factory of pojo.extensions
      console.log "INIT", fac
      factory.init?()
      for obj, object of pojo[factory.plural]
        console.log "INIT", fac, obj
        object?.init?()

  ###
  TODO this could be removed to ensure an app is entirely
       accessible through the pojo
  ###
  pojo.require = (args...) ->
    module.require args...

  ###
  The factory method produces extensions and provides functionality
  to the app. The objects created when calling the extension (its singular)
  are stored in a property (its plural).
  ###
  pojo.extension = (singular, options, factory) ->
    options ?= {}
    plural  = options.plural ?= "#{singular}s"
    url     = options.url    ?= "#{pojo.package.name}/#{plural}"

    factory ?= ->
      throw new Error "#{moduleName module}.#{singular} not implemented"

    # The container that holds the options of an app's extension
    pojo.extensions[singular] = options

    # The container that holds the extension's constructed objects
    pojo[plural] = {}

    product = (module, args...) =>
      # We'll do some filthy magic here
      # Sometimes we want to pass in a module in stead of a uid
      # In that case, the uid becomes the module name
      pojo[plural][moduleName module] = factory.call pojo, module, args...

    # The factory method exposed
    pojo[singular] = product
    product.options = options
    product

  pojo.bus = new events.EventEmitter

  pojo