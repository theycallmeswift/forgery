class Factory
  # Class Properties

  @factories: {}

  # Class Methods

  @clearFactories: =>
    for factory of @factories
      delete @factories[factory]

  constructor: (factoryName, options = {}) ->
    throw new Error('Error: Factory name is required') unless factoryName

    factoryDefinition = Factory.factories[factoryName]
    throw new Error("Error: Factory with key '#{factoryName}' is not defined") unless factoryDefinition

    return new extend({}, factoryDefinition.defaults, options)

  @define: (name, attributes = {}) ->
    throw new Error('Error: Factory.define requires a key') unless name

    @factories[name] = { name: name, defaults: attributes }

extend = (obj, others...) ->
  for source in others
    for key, value of source
      if typeof value == 'function'
        obj[key] = value()
      else
        obj[key] = value

  return obj

module.exports = Factory
