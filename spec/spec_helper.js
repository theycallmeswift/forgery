(function() {

  hat     = require('hat');
  Forgery = require('../');

  beforeEach(function() {
    this.addMatchers({
      toBeFunction: function() {
        return typeof this.actual === 'function'
      }
    });
  });

})();
