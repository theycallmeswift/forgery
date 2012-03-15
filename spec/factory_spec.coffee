describe 'Factory', ->

  it 'has no factories by default', ->
    expect(Factophobe.Factory.factories).toEqual { }

  describe '.clearFactories', ->
    beforeEach ->
      Factophobe.Factory.define 'foo', { bar: 'none' }
      Factophobe.Factory.define 'baz', { bat: true }

    it 'clears the list of factories', ->
      Factophobe.Factory.clearFactories()
      expect(Factophobe.Factory.factories['foo']).toBeUndefined()
      expect(Factophobe.Factory.factories['baz']).toBeUndefined()

  describe 'Factory', ->
    beforeEach ->
      Factophobe.Factory.define 'user',
        username: 'theycallmeswift'
        age: 22
        awesome: true
        occupation: ->
          return 'rockstar'

    it 'throws an error if no factory name is supplied', ->
      expect( -> Factophobe.Factory() ).toThrow "Error: Factory name is required"

    it 'throws an error the factory key is not defined', ->
      message = "Error: Factory with key 'unknownKey' is not defined"
      expect( -> Factophobe.Factory('unknownKey') ).toThrow message

    it 'creates a new object with the default properties', ->
      subject = Factophobe.Factory 'user'
      expect(subject).toEqual {
        username: 'theycallmeswift'
        age: 22
        awesome: true
        occupation: 'rockstar'
      }

    it 'extends the defaults with any options supplied', ->
      subject = Factophobe.Factory 'user', { age: 50, extra: 'yeahyeah' }
      expect(subject).toEqual {
        username: 'theycallmeswift'
        age: 50
        awesome: true
        occupation: 'rockstar'
        extra: 'yeahyeah'
      }

  describe '.define', ->
    beforeEach ->
      @name = 'user'
      @defaults = { foo: 'bar' }

      Factophobe.Factory.define @name, @defaults
      @subject = Factophobe.Factory.factories[@name]

    it 'uses the first argument as the key', ->
      Factophobe.Factory.define 'user2', { blah: 'blah' }
      expect(Factophobe.Factory.factories['user']).toBe @subject
      expect(Factophobe.Factory.factories['user2'].name).toBe 'user2'

    it 'uses the second argument as the factory defaults', ->
      expect(@subject.name).toEqual(@name)
      expect(@subject.defaults).toBe(@defaults)

    it 'uses an empty object for the defaults if none were supplied', ->
      Factophobe.Factory.define 'user2'
      expect(Factophobe.Factory.factories['user2'].defaults).toEqual {}

    it "throws an error if no key is supplied", ->
      expect( -> Factophobe.Factory.define() ).toThrow "Error: Factory.define requires a key"

    afterEach ->
      Factophobe.Factory.clearFactories()
