Cleetus = require '../lib/cleetus'

cleetus = new Cleetus()

describe 'cleetus', ->

  it 'should be defined', ->
    expect(Cleetus).toBeDefined()

  it 'should have private log method', ->
    expect(cleetus.log).not.toBeDefined()

  it 'should list all git enabled directories under cwd', ->
    expect(cleetus.ls).toBeDefined()
    cleetus.ls()
