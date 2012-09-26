[![build status](https://secure.travis-ci.org/theycallmeswift/forgery.png)](http://travis-ci.org/theycallmeswift/forgery)
# Forgery

Forgery is a set of testing tools for Node.js and client-side MVC
applications.  Specifically it's designed to integrate well with
popular testing frameworks like:

 - [Cucumber.js](https://github.com/cucumber/cucumber-js)
 - [Jasmine-Node](https://github.com/mhevery/jasmine-node)
 - [Nock](https://github.com/flatiron/nock)

## Installation & Setup

To install the latest stable version of Forgery, use npm with the following
command:

    npm install forgery

## Factory

`Forgery.Factory` is a JSON fixtures library for Node.js.  It is usful for
stubbing out API responses and creating JSON unique JSON objects for testing.

### Setup and Usage

Forgery's Factory functionality is heavily inspired by [Factory
Girl](https://github.com/thoughtbot/factory_girl).  In order to use it, all
you have to do is require it and define some factories.  For example:

    var Factory = require('forgery').Factory;

    Factory.define('MyFactory', {
      "foo": "bar",
    });

    ... etc ...

Now when ever you need to create a new factory, you have access to it through
the `Factory` method:

    Factory('MyFactory') 
    //=> { id: '9e55f9ad9411aea49d554ae4e0b5c306', foo:'bar' }

We can also easily override the default attributes by passing in an options
hash as a second parameter.

    Factory('MyFactory', { foo: 'tab' }) 
    //=> { id: '9e55f9ad9411aea49d554ae4e0b5c306', foo:'tab' }

#### Changing the ID field

Sometimes you will want the ID field to have a different format.  For instance,
if you are mocking Mongo objects, they have an `_id` attribute instead.  You
can specify to use a differnt ID field or none at all using the third parameter.

    // Alternative ID field
    Factory('MyFactory', { foo: 'tab' }, { idField: '_id' }) 
    //=> { _id: '9e55f9ad9411aea49d554ae4e0b5c306', foo:'tab' }

    // No ID field (must set explicitly to false)
    Factory('MyFactory', { foo: 'tab' }, { idField: false }) 
    //=> { foo:'tab' }

## License

```
/* ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 *
 * Swift <theycallmeswift@gmail.com> wrote this file. As long as you retain
 * this notice you can do whatever you want with this stuff. If we meet some
 * day, and you think this stuff is worth it, you can buy me a beer in return.
 * ----------------------------------------------------------------------------
 */
```
