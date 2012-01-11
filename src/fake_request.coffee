{ClientRequest, OutgoingMessage} = require 'http'

class FakeRequest extends ClientRequest

  # constructor
  #
  # This is a port of the native ClientRequest constructor.
  # The only difference is that no actual connection is
  # established with the remote server.
  #
  # @params {Object} a hash of url options
  # @params {Function} the callback
  #
  # TODO: Write tests for this

  constructor: (options, cb) ->
    OutgoingMessage.call(this)

    @agent = options.agent
    options.defaultPort = options.defaultPort || 80

    options.port = options.port || options.defaultPort
    options.host = options.hostname || options.host || 'localhost'
    options.setHost = true if options.setHost == undefined

    @socketPath = options.socketPath

    method = @method = (options.method || 'GET').toUpperCase()
    @path = options.path || '/'

    @on('response', cb) if cb

    unless Array.isArray(options.headers)
      if options.headers
        keys = Object.keys(options.headers)
        for key in keys
          @setHeader(key, options.headers[key])

      if options.host && !@getHeader('host') && options.setHost
        hostHeader = options.host

        if options.port && +options.port != options.defaultPort
          hostHeader += ":#{options.port}"

        @setHeader('Host', hostHeader)

    if options.auth && !@getHeader('Authorization')
      @setHeader('Authorization', "Basic #{new Buffer(options.auth).toString('base64')}")

    if method == 'GET' || method == 'HEAD' || method == 'CONNECT'
      @useChunkedEncodingByDefault = false
    else
      @useChunkedEncodingByDefault = true

    if Array.isArray(options.headers)
      @_storeHeader("#{@method} #{@path} HTTP/1.1\r\n", options.headers)
    else if @getHeader('expect')
      @_storeHeader("#{@method} #{@path} HTTP/1.1\r\n", @_renderHeaders())

  # end
  #
  # This is a port of the native ClientRequest's end method.
  # This sets all the final header and body data as normal
  # and sets the request to finished as would be expected.
  # Finally emits a 'finish' event (which may need to be
  # changed to something else)
  #
  # @params {Mixed} Data to write to body (array of Integers or String)
  # @params {String} encoding defaults to UTF8
  #
  # TODO: Write tests for this

  end: (data, encoding) ->
    return false if @finished

    @_implicitHeader()

    if data && !@_hasBody
      console.error("This type of response MUST NOT have a body. " +
                    "Ignoring data passed to end().")
      data = false

    @write(data, encoding) if data

    if @chunkedEncoding
      @_send("0\r\n#{@_trailer}\r\n")
    else
      @_send('')

    @finished = true

    @emit 'finish'

module.exports = FakeRequest
