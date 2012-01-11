class RequestHandler

  # constructor
  #
  # Initialize the requestStubs property to an empty array.
  constructor: () ->
    @requestStubs = []

  # addRequestStub
  #
  # Adds a request stub to the front of the requestStubs array.
  # Returns the stub for chaining.
  #
  # @params {Object} RequestStub
  # @return {Object} RequestStub
  addRequestStub: (stub) ->
    @requestStubs.unshift(stub)
    return stub

  # reset
  #
  # Resets the requestStubs property to an empty array.
  reset: () ->
    @requestStubs = []

module.exports = RequestHandler
