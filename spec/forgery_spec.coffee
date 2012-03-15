describe "Forgery", ->

  it "has a version property that matches the package", ->
    packageInfo = require '../package.json'
    expect(Forgery.version).toBe packageInfo.version

  it "exposes the Factory method", ->
    expect(Forgery.Factory).toBeFunction()
