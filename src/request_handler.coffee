url = require 'url'

class RequestHandler

  # constructor
  #
  # Initialize the requestStubs property to an empty array.

  constructor: () ->
    @requestStubs = {}

  # addRequestStub
  #
  # Adds a request stub to the front of the requestStubs array
  # for a given host. Returns the stub for chaining.
  #
  # @params {String} host string
  # @params {Object} RequestStub
  # @return {Object} RequestStub

  addRequestStub: (hostString, stub) ->
    host = RequestHandler.generateHostKey(hostString)
    if @requestStubs[host]
      @requestStubs[host].unshift(stub)
    else
      @requestStubs[host] = [stub]
    return stub

  # findFirstMatch
  #
  # Finds the first match for a FakeRequest and returns it.
  # If no match exists, returns false.
  #
  # @params {Object} Fake Request
  # @return {Mixed} Request Stub or false
  #
  # TODO: Fill in this method.

  findFirstMatch: (fakeRequest) ->
    false

  # generateHostKey
  #
  # Generates a standardized host key for a url. The format is:
  #
  #   protocol://username:password@host.com:port/
  #
  # Protocol defaults to http. Auth and port are both optional.
  #
  # @params {Mixed} url string or url options object
  # @return {String} host key
  #
  # TODO: Don't change case of AUTH info

  @generateHostKey: (urlString) ->
    if typeof urlString == 'string'
      _urlString = urlString.toLowerCase()
      _urlString = "http://#{_urlString}" unless /^^https?:\/\//.test(_urlString)

      parsedUrl = url.parse _urlString
    else
      parsedUrl = urlString

    throw new Error("Forgery: Invalid URL supplied ('#{urlString}')") unless parsedUrl.host

    protocol = parsedUrl.protocol || 'http:'

    auth = if parsedUrl.auth
      "#{parsedUrl.auth}@"
    else
      ''

    return "#{protocol}//#{auth}#{parsedUrl.host}/"

  # isLocalRequest
  #
  # Takes in a FakeRequest Object and returns true if it is
  # for a local request.
  #
  # @params {Object} Fake Request
  # @return {Boolean}

  @isLocalRequest: (fakeRequest) ->
    key = RequestHandler.generateHostKey(fakeRequest.Forgery?.options)
    return RequestHandler.isLocalhost(key)

  # isExternalRequest
  #
  # Takes in a FakeRequest Object and returns true if it is
  # for an external request.
  #
  # @params {Object} Fake Request
  # @return {Boolean}

  @isExternalRequest: (fakeRequest) ->
    key = RequestHandler.generateHostKey(fakeRequest.Forgery?.options)
    return !RequestHandler.isLocalhost(key)

  # isLocalhost
  #
  # Returns true if the url being requested is localhost.
  #
  # @params {String} url string
  # @return {Boolean}

  @isLocalhost: (urlString) ->
    _urlString = urlString.toLowerCase()
    parsedUrl = url.parse _urlString
    return parsedUrl.hostname in ['localhost', '0.0.0.0', '127.0.0.1']

  # reset
  #
  # Resets the requestStubs property to an empty object.
  #
  # TODO: Allow reset of a single host
  reset: () ->
    @requestStubs = {}

module.exports = RequestHandler
