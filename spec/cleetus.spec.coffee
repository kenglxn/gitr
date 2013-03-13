Cleetus = require '../lib/cleetus'
fs = require 'fs'
rimraf = require 'rimraf'
cp = require 'child_process'

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

  it 'should have function for executing a git command', ->
    expect(cleetus.do).toBeDefined()
    expect(cp.exec).toBeDefined();
    spyOn(cp, 'exec');
    cleetus.do 'status', '/Users/ken/dev/git/cleetus'
    expect(cp.exec).toHaveBeenCalled()
    expect(cp.exec.callCount).toBe(1)
    command = 'git --git-dir=/Users/ken/dev/git/cleetus/.git --work-tree=/Users/ken/dev/git/cleetus status'
    expect(cp.exec).toHaveBeenCalledWith(command)

  it 'should execute git command at cmd if path is not supplied', ->
    expect(cleetus.do).toBeDefined()
    expect(cp.exec).toBeDefined();
    spyOn(cp, 'exec');
    cleetus.do 'status'
    expect(cp.exec).toHaveBeenCalled()
    expect(cp.exec.callCount).toBe(1)
    command = 'git --git-dir=/Users/ken/dev/git/cleetus/.git --work-tree=/Users/ken/dev/git/cleetus status'
    expect(cp.exec).toHaveBeenCalledWith(command)

  it 'should execute git command recursively for all git enabled repos', ->
    expect(cleetus.do).toBeDefined()
    expect(cp.exec).toBeDefined();
    spyOn(cp, 'exec');
    cleetus.do 'status', 'testDir'
    expect(cp.exec).toHaveBeenCalled()
    expect(cp.exec.callCount).toBe(2)
    expect(cp.exec.calls[0].args[0]).toBe('git --git-dir=testDir/withGitRepo/.git --work-tree=testDir/withGitRepo status')
    expect(cp.exec.calls[1].args[0]).toBe('git --git-dir=testDir/withGitRepoAtSecondLevel/secondLevel/.git --work-tree=testDir/withGitRepoAtSecondLevel/secondLevel status')

