RequestHandler = require './request_handler'

_instance = undefined

getInstance = () ->
  return _instance ?= new RequestHandler()

module.exports = exports = (host, options = { }) ->
  if host
    return getInstance().addInterceptor(host, options)
  else
    throw new Error("Swock: Host must be provided.")

# Swock Version
exports.version = "0.0.0"

# RequestHandler Instance
exports._instance = getInstance()

# Expose EventListener Methods to user
#
# For information on these methods, check out the Node.js
# EventEmitter docs here:
# http://nodejs.org/docs/latest/api/events.html#events.EventEmitter

exports.on = exports.addListener = (event, listener) ->
  getInstance().on(event, listener)

exports.once = (event, listener) ->
  getInstance().once(event, listener)

exports.removeListener = (event, listener) ->
  getInstance().removeListener(event, listener)

exports.removeAllListeners = (event) ->
  if arguments.length == 0
    getInstance().removeAllListeners()
  else
    getInstance().removeAllListeners(event)
