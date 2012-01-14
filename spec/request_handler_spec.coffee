RequestHandler = require '../src/request_handler'

_ = require 'underscore'

describe "RequestHandler", ->

  describe "contructor", ->

    it "initializes requestStubs to an empty object", ->
      rh = new RequestHandler()
      expect(rh.requestStubs).toBeEmpty()

  describe "#addRequstStub", ->

    beforeEach ->
      @rh = new RequestHandler()
      @host = "http://foo.bar/"
      @stub = { some: 'stub' }

    it "creates a property in requeststubs for the supplied host", ->
      expect(@rh.requestStubs[@host]).not.toBeDefined()
      @rh.addRequestStub(@host, @stub)
      expect(@rh.requestStubs[@host]).toBeDefined()

    it "uses the generateHostKey method to generate the key", ->
      @rh.addRequestStub('foo.com', @stub)
      expect(@rh.requestStubs['foo.com']).not.toBeDefined()
      expect(@rh.requestStubs['http://foo.com/']).toBeDefined()

    it "creates a different property in requestStubs for unknown hosts", ->
      @rh.addRequestStub(@host, @stub)
      @rh.addRequestStub("http://new.host/", @stub)
      expect(@rh.requestStubs[@host]).toBeDefined()
      expect(@rh.requestStubs["http://new.host/"]).toBeDefined()
      expect(@rh.requestStubs[@host].length).toBe 1, "Number of stubs for host"
      expect(@rh.requestStubs["http://new.host/"].length).toBe 1, "Number of stubs for host"

    it "adds the object to the requestStubs array for a given host", ->
      @rh.addRequestStub(@host, @stub)

      expect(@rh.requestStubs[@host].length).toBe 1, "number of stubs in requestStubs array"
      expect(@rh.requestStubs[@host][0]).toBe @stub

    it "prepends additional objects to the requestStubs array for a known host", ->
      @rh.addRequestStub(@host, @stub)
      newStub = { foo: 'bar' }
      @rh.addRequestStub(@host, newStub)

      expect(@rh.requestStubs[@host].length).toBe 2, "number of stubs in requestStubs array"
      expect(@rh.requestStubs[@host][0]).toBe newStub

    it "returns the stub for chaining", ->
      result = @rh.addRequestStub(@host, @stub)

      expect(result).toBe @stub, "returns the added stub"

  describe "#reset", ->

    beforeEach ->
      @rh = new RequestHandler()
      @host = 'http://www.foo.com/'
      @rh.addRequestStub(@host, { some: 'stub' })
      @rh.addRequestStub(@host, { someOther: 'Awesome_stub' })

    it "removes all the stubs from the requestStubs array", ->
      @rh.reset()
      expect(@rh.requestStubs[@host]).not.toBeDefined()
      expect(@rh.requestStubs).toBeEmpty()

  describe ".generateHostKey", ->

    it "returns a host key for a url", ->
      url = "http://foo:bar@somedomain.com:8000/"
      expect(RequestHandler.generateHostKey(url)).toBe "http://foo:bar@somedomain.com:8000/"

    it "throws an error on invalid urls", ->
      expect( () -> RequestHandler.generateHostKey('')).toThrow(Error("Forgery: Invalid URL supplied ('')"))
      expect( () -> RequestHandler.generateHostKey('-')).toThrow(Error("Forgery: Invalid URL supplied ('-')"))
      expect( () -> RequestHandler.generateHostKey('https://')).toThrow(Error("Forgery: Invalid URL supplied ('https://')"))
      expect( () -> RequestHandler.generateHostKey('foo.com')).not.toThrow()

    it "lowercases the url", ->
      url = "HTTP://FOO:BAR@SOMEDOMAIN.COM:8000/"
      expect(RequestHandler.generateHostKey(url)).toBe "http://foo:bar@somedomain.com:8000/"

    it "appends http if no protocol is supplied", ->
      url = "foo:bar@somedomain.com:8000"
      expect(RequestHandler.generateHostKey(url)).toBe "http://foo:bar@somedomain.com:8000/"

    it "optionally includes port", ->
      url = "https://foo:bar@somedomain.com"
      expect(RequestHandler.generateHostKey(url)).toBe "https://foo:bar@somedomain.com/"

    it "optionally includes auth", ->
      url = "https://somedomain.com"
      expect(RequestHandler.generateHostKey(url)).toBe "https://somedomain.com/"

    it "appends a trailing slash if missing", ->
      url = "http://foo:bar@somedomain.com:8000"
      expect(RequestHandler.generateHostKey(url)).toBe "http://foo:bar@somedomain.com:8000/"

  describe ".isLocalhost", ->
    it "returns true for localhost domains", ->
      url = "http://localhost:8000"
      expect(RequestHandler.isLocalhost(url)).toBe true

      url = "http://0.0.0.0:8000"
      expect(RequestHandler.isLocalhost(url)).toBe true

      url = "http://127.0.0.1:8000"
      expect(RequestHandler.isLocalhost(url)).toBe true

    it "returns false for non-localhost domains", ->
      url = "http://foo.bar:8000"
      expect(RequestHandler.isLocalhost(url)).toBe false

      url = "http://not.localhost.com:8000"
      expect(RequestHandler.isLocalhost(url)).toBe false
