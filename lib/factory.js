(function() {
  var Factory, extend,
    __slice = Array.prototype.slice;

  Factory = (function() {

    Factory.factories = {};

    Factory.clearFactories = function() {
      var factory, _results;
      _results = [];
      for (factory in Factory.factories) {
        _results.push(delete Factory.factories[factory]);
      }
      return _results;
    };

    function Factory(factoryName, options) {
      var factoryDefinition;
      if (options == null) options = {};
      if (!factoryName) throw new Error('Error: Factory name is required');
      factoryDefinition = Factory.factories[factoryName];
      if (!factoryDefinition) {
        throw new Error("Error: Factory with key '" + factoryName + "' is not defined");
      }
      return new extend({}, factoryDefinition.defaults, options);
    }

    Factory.define = function(name, attributes) {
      if (attributes == null) attributes = {};
      if (!name) throw new Error('Error: Factory.define requires a key');
      return this.factories[name] = {
        name: name,
        defaults: attributes
      };
    };

    return Factory;

  }).call(this);

  extend = function() {
    var key, obj, others, source, value, _i, _len;
    obj = arguments[0], others = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    for (_i = 0, _len = others.length; _i < _len; _i++) {
      source = others[_i];
      for (key in source) {
        value = source[key];
        if (typeof value === 'function') {
          obj[key] = value();
        } else {
          obj[key] = value;
        }
      }
    }
    return obj;
  };

  module.exports = Factory;

}).call(this);
