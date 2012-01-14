_ = require 'underscore'

beforeEach () ->
  @addMatchers({
    toBeInstanceOf: (expected) ->
      @message = () ->
        ["expected #{@actual} to be instanceof #{expected}",
         "expected #{@actual} not to be instanceof #{expected}"]

      return @actual instanceof expected

    toBeTypeOf: (expected) ->
      @message = () ->
        ["expected #{typeof @actual} to be typeof #{expected}",
         "expected #{typeof @actual} not to be typeof #{expected}"]

      return typeof @actual == expected

    toBeEmpty: () ->
      @message = () ->
        ["expected #{@actual} to be empty.",
         "expected #{@actual} not to be empty."]

      return _.isEmpty(@actual)
  })
