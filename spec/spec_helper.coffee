beforeEach () ->
  @addMatchers({
    toBeInstanceOf: (expected) ->
      @message = () ->
        ["expected #{@actual} to be instanceof #{expected}",
         "expected #{@actual} not to be instanceof #{expected}"]

      return @actual instanceof expected
  })
