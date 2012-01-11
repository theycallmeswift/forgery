# Native Dependencies
{EventEmitter} = require 'events'
http = require 'http'
https = require 'https'
FakeRequest = require './fake_request'

# Cache the Native request functions so we can restore if needed
nativeHttpRequest = http.request
nativeHttpsRequest = https.request

class Forgery extends EventEmitter

  # Forgery Version
  version: "0.0.0"

  # Forgery Default Configuration
  defaultConfig: {
    allowLocalRequests: true,
    allowExternalRequests: false,
    enabled: true
  }

  # constructor
  #
  # This is called automatically when you require Forgery.
  # Applys the default configuration to the class and starts
  # the HTTP and HTTPS interceptor.
  constructor: () ->
    # Apply the default configuration
    @config = @defaultConfig

    # Enable the interceptor
    @enable()

  processRequest: (options, callback) ->
    console.log "***************************************"
    console.log "Request Received"
    console.log "***************************************"
    req = new FakeRequest(options, callback)
    req.on 'finish', () ->
      console.log "***************************************"
      console.log "Request FINSIHED"
      console.log "***************************************"
    return req

  # enable
  #
  # Enables Forgery. Overrides the default http and https
  # request methods with the processRequest function. Emits
  # an 'enabled' event when enabled.
  enable: () ->
    http.request = @processRequest
    https.request = @processRequest
    @emit('enabled')

  # disable
  #
  # Disables Forgery. Restores the default http and https
  # request methods. Emits a 'disabled' event when disabled.
  disable: () ->
    http.request = nativeHttpRequest
    https.request = nativeHttpsRequest
    @emit('disabled')

  # disableExternalRequests
  #
  # Disables requests to non local hosts.
  #
  # @return {Object} self
  disableExternalRequests: () ->
    @config.allowExternalRequests = false
    return @

  # disableLocalRequests
  #
  # Disables requests to local hosts.
  #
  # @return {Object} self
  disableLocalRequests: () ->
    @config.allowLocalRequests = false
    return @

  # enableExternalRequests
  #
  # Enables requests to non local hosts.
  #
  # @return {Object} self
  enableExternalRequests: () ->
    @config.allowExternalRequests = true
    return @

  # enableLocalRequests
  #
  # Enables requests to local hosts.
  #
  # @return {Object} self
  enableLocalRequests: () ->
    @config.allowLocalRequests = true
    return @

module.exports = new Forgery()
