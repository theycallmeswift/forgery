describe "Factophobe", ->

  it "has a version property that matches the package", ->
    packageInfo = require '../package.json'
    expect(Factophobe.version).toBe packageInfo.version

  it "exposes the Factory method", ->
    expect(Factophobe.Factory).toBeFunction()
