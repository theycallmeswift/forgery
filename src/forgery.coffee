# Native Dependencies
{EventEmitter} = require 'events'
http = require 'http'
https = require 'https'
FakeRequest = require './fake_request'
FakeResponse = require './fake_response'

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
  #
  # TODO: Instantiate a RequestHandler to handle spys and mocks

  constructor: () ->
    # Apply the default configuration
    { @allowLocalRequests, @allowExternalRequests, @enabled } = @defaultConfig

    @_nativeHttpRequest = nativeHttpRequest
    @_nativeHttpsRequest = nativeHttpsRequest

    # Enable the interceptor
    @enable()

  # generateFakeRequest
  #
  # This is the method that wraps the native HTTP request method.
  # Returns an instance of the FakeRequest object that can be built
  # into what looks like a real ClientRequest object.
  #
  # TODO: Emit a 'receivedRequest' event with the details
  # TODO: Handle HTTP and HTTPS requests differently

  generateFakeRequest: (options, callback) ->
    req = new FakeRequest(options, callback)
    req.on 'requestEnded', =>
      @processRequest(req)
    return req

  # processRequest
  #
  # Called when we have a completely defined request that we can process.
  # If a match exists for the supplied FakeRequest object, then we should
  # delegate to the Interceptor to handle responding. Otherwise, we should
  # validate that the request is allowed and pass it along to the native
  # request method. If the request is not allowed, we should throw an error.
  processRequest: (fakeRequest) ->
    # Complete psudo code
    # match = @RequestHandler.isInterestedIn(fakeRequest)
    # if match
    #   @emit 'interceptedRequest', requestData
    #
    #   response = match.generateResponseFor(fakeRequest)
    #
    #   fakeRequest.emit 'response', response
    #   response.transmitData()
    # else
    #   # Generate a real request and delegate the fakeRequest
    #   if isExternalRequest(fakeRequest) && !@allowExternalRequests
    #     throw new Error("Forgery: External requests are disabled.")
    #   else if isLocalRequest(fakeRequest) && !@allowLocalRequests
    #     throw new Error("Forgery: Local requests are disabled.")
    #
    #   throw new Error("Forgery: Generating real requests not yet implemented")

  # enable
  #
  # Enables Forgery. Overrides the default http and https
  # request methods with the generateFakeRequest function. Emits
  # an 'enabled' event when enabled.
  enable: () ->
    http.request = @generateFakeRequest
    https.request = @generateFakeRequest
    @emit('enabled')

  # disable
  #
  # Disables Forgery. Restores the default http and https
  # request methods. Emits a 'disabled' event when disabled.
  disable: () ->
    http.request = @_nativeHttpRequest
    https.request = @_nativeHttpsRequest
    @emit('disabled')

  # disableExternalRequests
  #
  # Disables requests to non local hosts.
  #
  # @return {Object} self
  disableExternalRequests: () ->
    @allowExternalRequests = false
    return @

  # disableLocalRequests
  #
  # Disables requests to local hosts.
  #
  # @return {Object} self
  disableLocalRequests: () ->
    @allowLocalRequests = false
    return @

  # enableExternalRequests
  #
  # Enables requests to non local hosts.
  #
  # @return {Object} self
  enableExternalRequests: () ->
    @allowExternalRequests = true
    return @

  # enableLocalRequests
  #
  # Enables requests to local hosts.
  #
  # @return {Object} self
  enableLocalRequests: () ->
    @allowLocalRequests = true
    return @

module.exports = new Forgery()
