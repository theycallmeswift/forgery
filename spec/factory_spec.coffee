describe 'Factory', ->

  it 'has no factories by default', ->
    expect(Forgery.Factory.factories).toEqual { }

  describe '.clearFactories', ->
    beforeEach ->
      Forgery.Factory.define 'foo', { bar: 'none' }
      Forgery.Factory.define 'baz', { bat: true }

    it 'clears the list of factories', ->
      Forgery.Factory.clearFactories()
      expect(Forgery.Factory.factories['foo']).toBeUndefined()
      expect(Forgery.Factory.factories['baz']).toBeUndefined()

  describe 'Factory', ->
    beforeEach ->
      Forgery.Factory.define 'user',
        username: 'theycallmeswift'
        age: 22
        awesome: true
        occupation: ->
          return 'rockstar'

    it 'throws an error if no factory name is supplied', ->
      expect( -> Forgery.Factory() ).toThrow "Error: Factory name is required"

    it 'throws an error the factory key is not defined', ->
      message = "Error: Factory with key 'unknownKey' is not defined"
      expect( -> Forgery.Factory('unknownKey') ).toThrow message

    it 'creates a new object with the default properties', ->
      spyOn(Forgery.Factory, 'rack').andReturn('1a2b3c')

      subject = Forgery.Factory 'user'
      expect(subject).toEqual {
        id: '1a2b3c'
        username: 'theycallmeswift'
        age: 22
        awesome: true
        occupation: 'rockstar'
      }

    it 'allows you to specify the id field using the idField option', ->
      spyOn(Forgery.Factory, 'rack').andReturn('1a2b3c')

      subject = Forgery.Factory 'user', {}, { idField: '_id' }
      expect(subject).toEqual {
        _id: '1a2b3c'
        username: 'theycallmeswift'
        age: 22
        awesome: true
        occupation: 'rockstar'
      }

    it 'returns no id field if idField is set to false', ->
      spyOn(Forgery.Factory, 'rack').andReturn('1a2b3c')

      subject = Forgery.Factory 'user', {}, { idField: false }
      expect(subject).toEqual {
        username: 'theycallmeswift'
        age: 22
        awesome: true
        occupation: 'rockstar'
      }

    it 'extends the defaults with any options supplied', ->
      subject = Forgery.Factory 'user', { id: 1, age: 50, extra: 'yeahyeah' }
      expect(subject).toEqual {
        id: 1
        username: 'theycallmeswift'
        age: 50
        awesome: true
        occupation: 'rockstar'
        extra: 'yeahyeah'
      }

    it 'throws an error when it runs out of unique ids', ->
      rack = hat.rack(1, 2)
      spyOn(Forgery.Factory, 'rack').andCallFake(rack)

      user1 = Forgery.Factory 'user'
      user2 = Forgery.Factory 'user'

      expect( -> Forgery.Factory 'user' ).toThrow('too many ID collisions, use more bits')

  describe '.define', ->
    beforeEach ->
      @name = 'user'
      @defaults = { foo: 'bar' }

      Forgery.Factory.define @name, @defaults
      @subject = Forgery.Factory.factories[@name]

    it 'uses the first argument as the key', ->
      Forgery.Factory.define 'user2', { blah: 'blah' }
      expect(Forgery.Factory.factories['user']).toBe @subject
      expect(Forgery.Factory.factories['user2'].name).toBe 'user2'

    it 'uses the second argument as the factory defaults', ->
      expect(@subject.name).toEqual(@name)
      expect(@subject.defaults).toBe(@defaults)

    it 'uses an empty object for the defaults if none were supplied', ->
      Forgery.Factory.define 'user2'
      expect(Forgery.Factory.factories['user2'].defaults).toEqual {}

    it "throws an error if no key is supplied", ->
      expect( -> Forgery.Factory.define() ).toThrow "Error: Factory.define requires a key"

    afterEach ->
      Forgery.Factory.clearFactories()
