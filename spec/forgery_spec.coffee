{EventEmitter} = require 'events'
fs = require 'fs'
http = require 'http'
https = require 'https'

Forgery = require '../src/forgery'
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
      expect(Forgery.config).toEqual Forgery.defaultConfig

  describe "#enable", ->
    beforeEach ->
      http.request = () ->
      https.request = () ->
      Forgery.enable()

    it "wraps the native http request method", ->
      expect(http.request).toBe Forgery.processRequest

    it "wraps the native https request method", ->
      expect(https.request).toBe Forgery.processRequest

  describe "#disable", ->
    beforeEach ->
      Forgery.disable()

    it "restores the native http request method", ->
      expect(http.request).not.toBe Forgery.processRequest

    it "restores the native https request method", ->
      expect(https.request).not.toBe Forgery.processRequest

  describe "#disableExternalRequests", ->
    it "sets allowExternalRequests to false", ->
      Forgery.config.allowExternalRequests = true
      Forgery.disableExternalRequests()
      expect(Forgery.config.allowExternalRequests).toBe false

  describe "#disableLocalRequests", ->
    it "sets allowLocalRequests to false", ->
      Forgery.config.allowLocalRequests = true
      Forgery.disableLocalRequests()
      expect(Forgery.config.allowLocalRequests).toBe false

  describe "#enableExternalRequests", ->
    it "sets allowExternalRequests to true", ->
      Forgery.config.allowExternalRequests = false
      Forgery.enableExternalRequests()
      expect(Forgery.config.allowExternalRequests).toBe true

  describe "#enableLocalRequests", ->
    it "sets allowLocalRequests to true", ->
      Forgery.config.allowLocalRequests = false
      Forgery.enableLocalRequests()
      expect(Forgery.config.allowLocalRequests).toBe true
