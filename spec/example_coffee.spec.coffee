example = require '../lib/example'

describe 'example coffee spec', ->

  it 'should bar', ->
    expect(example.foo()).toBe('bar')

