_    = require 'lodash'

# TODO
# There should be a generic way to 'emit' the end
# of the endpoint.

{signaturify} = require './signature'

# The endpoint decorator
# The default returns a function that validates and populates
# its arguments through a `params` attribute on the options
#
# This allows us to expose functions as API endpoints directly,
# while retaining full 'normal' javascript behaviour.
module.exports = (uid, options, callback) ->
  _.defaults options ?= {},
    method: 'POST'
    url:    "/#{@url}/#{uid}"

  func = signaturify options.params, callback ? ->
    throw new Error "Not Implemented"

  func.options = options
  func
