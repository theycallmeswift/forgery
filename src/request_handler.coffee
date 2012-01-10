{EventEmitter} = require 'events'
http = require 'http'
_ = require 'underscore'
url = require 'url'

Interceptor = require './interceptor'

# Cache the native request method in case we want to restore
nativeHttpRequest = http.request

class RequestHandler extends EventEmitter

  constructor: () ->
    http.request = @processRequest
    @interceptors = {}

  # addInterceptor
  #
  # Adds an interceptor to the interceptors hash or fetches the existing
  # one for the given host. Emits a 'newInterceptor' event containing the
  # added interceptor when a new host is added.
  #
  # @param  {String} base url to intercept
  # @param  {Object} interceptor options
  # @return {Object} Interceptor

  addInterceptor: (urlString, options = {}) ->
    host = RequestHandler.generateHostKey(urlString)
    if @interceptors[host]
      return @interceptors[host]
    else
      @interceptors[host] = new Interceptor(host, options)
      @emit("newInterceptor", @interceptors[host])
      return @interceptors[host]

  # removeInteceptor
  #
  # Removes the interceptor for a given host. Returns true if there was
  # an interceptor for the supplied url else false. Also, Emits an
  # interceptorRemoved event with the removed host if successful.
  #
  # @param  {String} url to remove interceptor from
  # @return {boolean} success

  removeInterceptor: (urlString) ->
    host = RequestHandler.generateHostKey(urlString)
    if @interceptors[host]
      delete @interceptors[host]
      @emit("removedInterceptor", host)
      return true
    else
      return false

  # generateHostKey
  #
  # Generates a host key for a supplied urlString. Host keys are in the
  # format "protocol://host.name:port/". If no protocol is supplied, it
  # defaults to http and if no port is supplied, the ":port" portion is
  # omitted.
  #
  # @param  {String} url to convert to key
  # @return {String} key for supplied url

  @generateHostKey: (urlString) ->
    parsedUrl = url.parse(urlString)

    if urlString.indexOf('://') != -1 and parsedUrl.hostname
      protocol = parsedUrl.protocol ? "http:"

      port = ""
      if parsedUrl.port
        port = ":#{parsedUrl.port}"

      return "#{protocol}//#{parsedUrl.hostname}#{port}/"
    else
      throw new Error("Swock: Invalid URL supplied ('#{urlString}')")

  processRequest: (options, callback) ->
    console.log("Recieved Request")
    nativeHttpRequest.apply(http, arguments)

module.exports = RequestHandler
