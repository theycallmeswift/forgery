RequestHandler = require '../src/request_handler'

_ = require 'underscore'

describe "RequestHandler", ->

  describe "contructor", ->

    it "initializes requestStubs to an empty array", ->
      rh = new RequestHandler()
      expect(_.isArray(rh.requestStubs)).toBe true, "requestStubs is an array"

  describe "#addRequstStub", ->

    beforeEach ->
      @rh = new RequestHandler()
      @stub = { some: 'stub' }

    it "adds the object to the requestStubs array", ->
      @rh.addRequestStub(@stub)

      expect(@rh.requestStubs.length).toBe 1, "number of stubs in requestStubs array"
      expect(@rh.requestStubs[0]).toBe @stub

    it "prepends additional objects to the requestStubs array", ->
      @rh.addRequestStub(@stub)
      newStub = { foo: 'bar' }
      @rh.addRequestStub(newStub)

      expect(@rh.requestStubs.length).toBe 2, "number of stubs in requestStubs array"
      expect(@rh.requestStubs[0]).toBe newStub

    it "returns the stub for chaining", ->
      result = @rh.addRequestStub(@stub)

      expect(result).toBe @stub, "returns the added stub"

  describe "#reset", ->

    beforeEach ->
      @rh = new RequestHandler()
      @rh.addRequestStub({ some: 'stub' })
      @rh.addRequestStub({ someOther: 'Awesome_stub' })

    it "removes all the stubs from the requestStubs array", ->
      @rh.reset()
      expect(@rh.requestStubs.length).toBe 0, "number of stubs in requestStubs array"

