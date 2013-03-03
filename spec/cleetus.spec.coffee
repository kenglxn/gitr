Cleetus = require '../lib/cleetus'

cleetus = new Cleetus()

describe 'cleetus', ->

  it 'should be defined', ->
    expect(Cleetus).toBeDefined()

  it 'should have private log method', ->
    expect(cleetus.log).not.toBeDefined()

  it 'should list all git enabled directories under cwd', ->
    expect(cleetus.ls).toBeDefined()

#   use fs.readdir to check fir .git as child,
#     if it is present add the directory to list of git dirs
#     if not recurse
    cleetus.ls()
