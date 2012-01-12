{IncomingMessage} = require 'http'

class FakeResponse extends IncomingMessage

  constructor: () ->
    super false

  destroy: (err) ->
    return

  pause: () ->
    @_paused = true

module.exports = FakeResponse
