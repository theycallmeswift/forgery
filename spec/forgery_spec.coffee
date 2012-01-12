{EventEmitter} = require 'events'
fs = require 'fs'
http = require 'http'
https = require 'https'

Forgery = require '../src/forgery'
FakeRequest = require '../src/fake_request'
RequestHandler = require '../src/request_handler'

describe "Forgery", ->

  describe "Singleton", ->
    it "always returns the same instance of the Forgery object", ->
      Forgery2 = require '../src/forgery'
      expect(Forgery2).toBe Forgery

    it "has a version property that contains the current version of Forgery", ->
      packageFile = fs.readFileSync("#{__dirname}/../package.json")
      package = JSON.parse(packageFile)

      expect(Forgery.version).toBe(package.version)

    it "extends the native EventEmitter", ->
      expect(Forgery).toBeInstanceOf EventEmitter

    it "sets config equal to the default configuration options", ->
      config = {
        enabled: Forgery.enabled,
        allowLocalRequests: Forgery.allowLocalRequests,
        allowExternalRequests: Forgery.allowExternalRequests
      }
      expect(config).toEqual Forgery.defaultConfig

    it "makes the native http and https request methods accessible vi properties", ->
      # TODO: Test that they are callable functions
      expect(Forgery._nativeHttpRequest).toBeDefined()
      expect(Forgery._nativeHttpsRequest).toBeDefined()

  describe "#generateFakeRequest", ->

    beforeEach ->
      @options = { host: 'http://foo.bar', port: '9000', method: 'HEAD' }
      @cb = -> return
      @request = Forgery.generateFakeRequest(@options, @cb)

    it "returns an instance of FakeRequest", ->
      expect(@request).toBeInstanceOf FakeRequest
      expect(@request.Forgery).toBeDefined()

    it "listens for the requestEnded event to handle interception", ->
      spyOn(Forgery, 'processRequest')
      @request.end()
      expect(Forgery.processRequest).toHaveBeenCalledWith(@request)

  describe "#enable", ->
    # TODO: Show that requests are intercepted when enabled

    beforeEach ->
      http.request = () ->
      https.request = () ->
      Forgery.enable()

    it "wraps the native http request method", ->
      expect(http.request).not.toBe Forgery._nativeHttpRequest
      expect(http.request).toBe Forgery.generateFakeRequest

    it "wraps the native https request method", ->
      expect(https.request).not.toBe Forgery._nativeHttpsRequest
      expect(https.request).toBe Forgery.generateFakeRequest

  describe "#disable", ->
    # TODO: Show that requests not are intercepted when disabled

    beforeEach ->
      Forgery.disable()

    it "restores the native http request method", ->
      expect(http.request).toBe Forgery._nativeHttpRequest
      expect(http.request).not.toBe Forgery.generateFakeRequest

    it "restores the native https request method", ->
      expect(https.request).toBe Forgery._nativeHttpsRequest
      expect(https.request).not.toBe Forgery.generateFakeRequest

  describe "#disableExternalRequests", ->
    # TODO: Show that external requests are disabled

    it "sets allowExternalRequests to false", ->
      Forgery.allowExternalRequests = true
      Forgery.disableExternalRequests()
      expect(Forgery.allowExternalRequests).toBe false

  describe "#disableLocalRequests", ->
    # TODO: Show that local requests are disabled

    it "sets allowLocalRequests to false", ->
      Forgery.allowLocalRequests = true
      Forgery.disableLocalRequests()
      expect(Forgery.allowLocalRequests).toBe false

  describe "#enableExternalRequests", ->
    # TODO: Show that external requests are enabled

    it "sets allowExternalRequests to true", ->
      Forgery.allowExternalRequests = false
      Forgery.enableExternalRequests()
      expect(Forgery.allowExternalRequests).toBe true

  describe "#enableLocalRequests", ->
    # TODO: Show that local requests are enabled

    it "sets allowLocalRequests to true", ->
      Forgery.allowLocalRequests = false
      Forgery.enableLocalRequests()
      expect(Forgery.allowLocalRequests).toBe true
