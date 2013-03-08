Cleetus = require '../lib/cleetus'
fs = require 'fs'

cleetus = new Cleetus()

describe 'cleetus', ->
  directoryStructure = [
    'testDir/withoutGitRepo',
    'testDir/withGitRepo',
    'testDir/withGitRepo/.git',
    'testDir/withGitRepoAtSecondLevel',
    'testDir/withGitRepoAtSecondLevel/secondLevel',
    'testDir/withGitRepoAtSecondLevel/secondLevel/.git',
  ]


  beforeEach ->
    for directory in directoryStructure
      do (directory) ->
        fs.mkdirSync(directory)

  afterEach ->
    for directory in directoryStructure.reverse()
      do (directory) ->
        fs.rmdirSync(directory)
    directoryStructure.reverse()

  it 'should be defined', ->
    expect(Cleetus).toBeDefined()

  it 'should have public log function', ->
    expect(cleetus.log).toBeDefined()

  it 'should list all git enabled directories under cwd', ->
    spyOn(cleetus, 'log')
    cleetus.ls('testDir')

    expect(cleetus.log).toHaveBeenCalled()
    expect(cleetus.log.callCount).toBe(2)
    expect(cleetus.log.calls[0].args[0]).toBe('testDir/withGitRepo')
    expect(cleetus.log.calls[1].args[0]).toBe('testDir/withGitRepoAtSecondLevel/secondLevel')


