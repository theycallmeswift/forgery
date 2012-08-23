describe "Forgery", ->

  it "exposes the Factory method", ->
    expect(Forgery.Factory).toBeFunction()
