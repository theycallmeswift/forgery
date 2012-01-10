RequestHandler = require '../src/request_handler'
Interceptor = require '../src/interceptor'
_ = require 'underscore'
http = require 'http'

describe "RequestHandler", ->

  describe "constructor", ->

    beforeEach ->
      spyOn(RequestHandler.prototype, 'processRequest').andCallFake( () ->
        return false
      )
      @rh = new RequestHandler()

    it "wraps the native http request method", ->
      options = { host: "foo" }
      callback = () ->
      http.request(options, callback)

      expect(@rh.processRequest.callCount).toBe 1, "number of calls to processRequest"
      expect(@rh.processRequest).toHaveBeenCalledWith(options, callback)

    it "intializes an empty interceptors object", ->
      interceptors = _.keys(@rh.interceptors)
      expect(interceptors.length).toBe 0, "number of defined interceptors"

  describe "#addInterceptor", ->
    beforeEach ->
      @rh = new RequestHandler()

    it "returns an interceptor", ->
      interceptor = @rh.addInterceptor("http://foo.bar")
      expect(interceptor).toBeInstanceOf(Interceptor)

    it "creates a new interceptor if one doesn't exist", ->
      expect(_.keys(@rh.interceptors).length).toBe 0, "number of interceptors"
      interceptor = @rh.addInterceptor("http://foo.bar")
      expect(_.keys(@rh.interceptors).length).toBe 1, "number of interceptors"

    it "returns the same interceptor if one already exists", ->
      interceptor1 = @rh.addInterceptor("http://foo.bar")
      interceptor2 = @rh.addInterceptor("http://foo.bar")
      expect(interceptor1).toBe interceptor2
      expect(_.keys(@rh.interceptors).length).toBe 1, "number of interceptors"

    it "returns different interceptors for different keys", ->
      interceptor1 = @rh.addInterceptor("http://foo.bar")
      interceptor2 = @rh.addInterceptor("http://not.known")
      expect(interceptor1).not.toBe interceptor2
      expect(_.keys(@rh.interceptors).length).toBe 2, "number of interceptors"

    it "used the .generateHostKey method to identify the host", ->
      interceptor = @rh.addInterceptor("http://foo.bar")
      key = RequestHandler.generateHostKey("http://foo.bar")
      expect(@rh.interceptors[key]).toBe interceptor

    it "emits a newInterceptor event when a new interceptor is added", ->
      eventFired = false
      response = undefined
      @rh.on('newInterceptor', (data) ->
        response = data
        eventFired = true
      )

      interceptor = @rh.addInterceptor("http://foo.bar")

      waitsFor () ->
        eventFired == true

      runs () ->
        expect(response).toBe interceptor, "emitted data is the returned interceptor"

    it "only emits newInterceptor events for new interceptors", ->
      eventFired = false
      counter = 0
      @rh.on('newInterceptor', (data) ->
        counter++
        eventFired = true
      )

      @rh.addInterceptor("http://foo.bar")
      @rh.addInterceptor("http://foo.bar")

      waitsFor () ->
        eventFired == true

      runs () ->
        expect(counter).toBe 1, "newInterceptor is only fired once"

  describe "#removeInterceptor", ->
    beforeEach ->
      @rh = new RequestHandler()
      @rh.addInterceptor("http://foo.bar")
      @rh.addInterceptor("http://www.example.com:8080")

    it "removes the interceptor for the supplied host", ->
      expect(@rh.interceptors['http://foo.bar/']).toBeDefined()
      @rh.removeInterceptor("http://foo.bar")
      expect(@rh.interceptors['http://foo.bar/']).toBeUndefined()

    it "doesn't remove any interceptors not matching the supplied host", ->
      expect(@rh.interceptors['http://www.example.com:8080/']).toBeDefined()
      @rh.removeInterceptor("http://foo.bar")
      expect(@rh.interceptors['http://www.example.com:8080/']).toBeDefined()

    it "returns true if the host was successfully removed", ->
      expect(@rh.removeInterceptor("http://foo.bar")).toBe true, "result of successful #removeInterceptor"

    it "returns false if the host was unsuccessfully removed", ->
      expect(@rh.removeInterceptor("http://non.existant/")).toBe false, "result of failed #removeInterceptor"

    it "emits a removedInterceptor event for successful removals", ->
      eventFired = false
      response = undefined
      @rh.on('removedInterceptor', (data) ->
        response = data
        eventFired = true
      )

      @rh.removeInterceptor("http://foo.bar")

      waitsFor () ->
        eventFired == true

      runs () ->
        expect(response).toBe "http://foo.bar/", "emitted data is the generatedHostKey"

  describe ".generateHostKey", ->
    it "throws an error if an invalid url is supplied", ->
      badUrls = [
        'foo',
        '',
        '://bar'
      ]

      _.each badUrls, (url) ->
        expect( ->
          RequestHandler.generateHostKey(url)
        ).toThrow(Error("Forgery: Invalid URL supplied ('#{url}')"))

    it "appends a trailing slash only if it is missing", ->
      urls = [
        'http://foo.bar',
        'http://foo.bar/'
      ]

      _.each urls, (url) ->
        expect(RequestHandler.generateHostKey(url)).toBe "http://foo.bar/"

    it "appends a port if one is supplied", ->
      expect(RequestHandler.generateHostKey('http://foo.bar:')).toBe "http://foo.bar/"
      expect(RequestHandler.generateHostKey('http://foo.bar:8080/')).toBe "http://foo.bar:8080/"
