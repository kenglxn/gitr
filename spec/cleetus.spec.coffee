Cleetus = require '../lib/cleetus'
fs = require 'fs'
rimraf = require 'rimraf'

cleetus = new Cleetus()

describe 'cleetus', ->
  directoryStructure = [
    'testDir',
    'testDir/withoutGitRepo',
    'testDir/withGitRepo',
    'testDir/withGitRepo/.git',
    'testDir/withGitRepoAtSecondLevel',
    'testDir/withGitRepoAtSecondLevel/secondLevel',
    'testDir/withGitRepoAtSecondLevel/secondLevel/.git',
  ]


  beforeEach ->
    for directory in directoryStructure
        unless fs.existsSync(directory)
          fs.mkdirSync(directory)
          fs.writeFileSync(directory + '/tmpFile', 'stuff') if directory.search('.git$') == -1

  afterEach ->
    rimraf.sync 'testDir'

  it 'should be defined', ->
    expect(Cleetus).toBeDefined()

  it 'should have help function', ->
    spyOn(cleetus, 'log')
    expect(cleetus.help).toBeDefined()
    cleetus.help()

  it 'should have public log function', ->
    expect(cleetus.log).toBeDefined()

  it 'should list all git enabled directories under given directory', ->
    spyOn(cleetus, 'log')
    cleetus.ls('testDir')

    expect(cleetus.log).toHaveBeenCalled()
    expect(cleetus.log.callCount).toBe(2)
    expect(cleetus.log.calls[0].args[0]).toBe('testDir/withGitRepo')
    expect(cleetus.log.calls[1].args[0]).toBe('testDir/withGitRepoAtSecondLevel/secondLevel')

  it 'should trim trailing slash list all git enabled directories under given directory', ->
    spyOn(cleetus, 'log')
    cleetus.ls('testDir')

    expect(cleetus.log).toHaveBeenCalled()
    expect(cleetus.log.callCount).toBe(2)
    expect(cleetus.log.calls[0].args[0]).toBe('testDir/withGitRepo')
    expect(cleetus.log.calls[1].args[0]).toBe('testDir/withGitRepoAtSecondLevel/secondLevel')

  it 'should ls from cwd if no argument is passed', ->
    spyOn(cleetus, 'log')
    cleetus.ls()
    expect(cleetus.log).toHaveBeenCalled()
    expect(cleetus.log.callCount).toBe(1)
    expect(cleetus.log.calls[0].args[0]).toBe(process.cwd())

  it 'should ls with absolute path', ->
    spyOn(cleetus, 'log')
    cleetus.ls('/Users/ken/dev/git/cleetus/testDir')
    expect(cleetus.log).toHaveBeenCalled()
    expect(cleetus.log.callCount).toBe(2)
    expect(cleetus.log.calls[0].args[0]).toBe('/Users/ken/dev/git/cleetus/testDir/withGitRepo')
    expect(cleetus.log.calls[1].args[0]).toBe('/Users/ken/dev/git/cleetus/testDir/withGitRepoAtSecondLevel/secondLevel')



