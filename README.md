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

    // No ID field (must set explicitly to false
    Factory('MyFactory', { foo: 'tab' }, { idField: false }) 
    //=> { foo:'tab' }

## An initial Warning

__WARNING__: Forgery is under heavy development and will not be subject to
semantic versioning standards until version `0.0.1`. Please be aware that API
changes may occur in the mean time.

## License

```
Copyright (C) 2012 Mike Swift

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
