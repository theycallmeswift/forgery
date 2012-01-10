fs = require 'fs'

Swock = require '../src/swock'
RequestHandler = require '../src/request_handler'
Interceptor = require '../src/interceptor'

describe "Swock", ->

  it "initializes a new RequestHandler as _instance", ->
    expect(Swock._instance).toBeInstanceOf(RequestHandler)

  it "has a version property that contains the current version of Swock", ->
    packageFile = fs.readFileSync("#{__dirname}/../package.json")
    package = JSON.parse(packageFile)

    expect(Swock.version).toBe(package.version)

  describe "#Swock", ->
    it "calls #addInterceptor on the RequestHandler instance", ->
      spyOn(Swock._instance, 'addInterceptor')
      Swock("http://foo.bar", { baz: "lalala" })
      expect(Swock._instance.addInterceptor).toHaveBeenCalledWith("http://foo.bar", { baz: "lalala" })

    it "returns an instance of Interceptor", ->
      expect(Swock("http://foo")).toBeInstanceOf(Interceptor)

    it "returns the same Interceptor for a known hostname", ->
      interceptor = Swock("http://foo:80/")
      expect(Swock("http://foo:80")).toBe(interceptor)

    it "returns a different Interceptor for known hostname but a different protocol or port", ->
      interceptor = Swock("http://foo:80/")
      expect(Swock("https://foo:80")).not.toBe(interceptor)
      expect(Swock("http://foo:8080")).not.toBe(interceptor)

    it "throws an error if no host is supplied", ->
      expect(() -> Swock()).toThrow(Error("Swock: Host must be provided."))

  describe "EventEmitter interface", ->
    emitter = undefined
    eventFired = undefined

    beforeEach ->
      emitter = Swock._instance
      eventFired = false

    it "has an interface for the #on method", ->
      response = null
      Swock.on 'someEvent', (message) ->
        response = message
        eventFired = true

      emitter.emit 'someEvent', 'foobar'

      waitsFor () ->
        eventFired = true

      runs () ->
        expect(response).toBe "foobar"

    it "has #addListener as an alias for #on", ->
      expect(Swock.addListener).toBe Swock.on

    it "has an interface for the #once method", ->
      counter = 0

      Swock.once 'someEvent', () ->
        counter++
        eventFired = true

      emitter.emit 'someEvent'
      emitter.emit 'someEvent'

      waitsFor () ->
        eventFired = true

      runs () ->
        expect(counter).toBe 1, "callback is only called once"

    it "has an interface for the #removeListener method", ->
      callbackOne = () -> true
      callbackTwo = () -> true

      Swock.on 'someEvent', callbackOne
      Swock.on 'someEvent', callbackTwo

      expect(emitter.listeners('someEvent').length).toBe 2, "number of listeners before removing"

      Swock.removeListener 'someEvent', callbackOne

      expect(emitter.listeners('someEvent').length).toBe 1, "number of listeners after removing"
      expect(emitter.listeners('someEvent')[0]).toBe callbackTwo, "only listener is callbackTwo"

    it "has an interface for the #removeAllListeners method", ->
      callback = () -> true

      Swock.on 'someEvent', callback
      Swock.on 'someEvent', callback
      Swock.on 'someOtherEvent', callback

      expect(emitter.listeners('someEvent').length).toBe 2, "number of listeners on someEvent"
      expect(emitter.listeners('someOtherEvent').length).toBe 1, "number of listeners on someOtherEvent"

      Swock.removeAllListeners('someOtherEvent')

      expect(emitter.listeners('someOtherEvent').length).toBe 0, "number of listeners on someOtherEvent after removing"
      expect(emitter.listeners('someEvent').length).toBe 2, "number of listeners on someEvent after removing someOtherEvent's listeners"

      Swock.removeAllListeners()

      expect(emitter.listeners('someEvent').length).toBe 0, "number of listeners on someEvent after removing all listeners"

    afterEach ->
      emitter.removeAllListeners()
