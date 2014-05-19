_ = require 'lodash'

###
 * Return a minimal representation of an object.
###
minifest = (obj) ->
  options = obj.options ? obj ? {}

  name: options.name
  url:  options.url

###
 * Return the full spec of an object, with mini versions of all
 * its extensions.
###
manifest = (obj) ->
  options = obj?.options ? obj ? {}

  result = _.cloneDeep options

  if obj?.extensions?
    result.extensions = {}
    for key, extension of obj.extensions
      result.extensions[key] = minifest extension

  result

module.exports = {minifest, manifest}