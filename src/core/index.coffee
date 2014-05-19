app            = require './app'
endpoint       = require './endpoint'
signature      = require './signature'
manifest       = require './manifest'
module.exports =
  app:         app
  endpoint:    endpoint

  parse:       signature.parse
  clean:       signature.clean
  signaturify: signature.signaturify

  minifest:    manifest.minifest
  manifest:    manifest.manifest
