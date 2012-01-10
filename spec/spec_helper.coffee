beforeEach () ->
  @addMatchers({
    toBeInstanceOf: (expected) ->
      @message = () ->
        "expected #{@actual} to be instanceof #{expected}"

      return @actual instanceof expected
  })
