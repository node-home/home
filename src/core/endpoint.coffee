_    = require 'lodash'

# TODO
# There should be a generic way to 'emit' the end
# of the endpoint.

{signaturify} = require './signature'

moduleEndpoint = (module) ->
  switch
    when module.url? then module.url
    when module.options?.url? then module.options.url
    else "/#{module}"


# The endpoint decorator
# The default returns a function that validates and populates
# its arguments through a `params` attribute on the options
#
# This allows us to expose functions as API endpoints directly,
# while retaining full 'normal' javascript behaviour.
module.exports = (module, options, callback) ->
  _.defaults options ?= {},
    method: 'POST'
    url: moduleEndpoint module

  func = signaturify options.params, callback ? ->
    throw new Error "#{module} callback not Implemented"

  func.options = options
  func
