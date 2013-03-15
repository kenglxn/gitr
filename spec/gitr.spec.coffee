GitR = require '../lib/gitr'
fs = require 'fs'
rimraf = require 'rimraf'
cp = require 'child_process'

gitr = new GitR()

describe 'gitr', ->
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
    expect(GitR).toBeDefined()

  it 'should list all git enabled directories under given directory', ->
    spyOn(console, 'log')
    gitr.ls('testDir')

    expect(console.log).toHaveBeenCalled()
    expect(console.log.callCount).toBe(2)
    expect(console.log.calls[0].args[0]).toBe('testDir/withGitRepo')
    expect(console.log.calls[1].args[0]).toBe('testDir/withGitRepoAtSecondLevel/secondLevel')

  it 'should trim trailing slash list all git enabled directories under given directory', ->
    spyOn(console, 'log')
    gitr.ls('testDir')

    expect(console.log).toHaveBeenCalled()
    expect(console.log.callCount).toBe(2)
    expect(console.log.calls[0].args[0]).toBe('testDir/withGitRepo')
    expect(console.log.calls[1].args[0]).toBe('testDir/withGitRepoAtSecondLevel/secondLevel')

  it 'should ls from cwd if no argument is passed', ->
    spyOn(console, 'log')
    gitr.ls()
    expect(console.log).toHaveBeenCalled()
    expect(console.log.callCount).toBe(1)
    expect(console.log.calls[0].args[0]).toBe(process.cwd())

  it 'should ls with absolute path', ->
    spyOn(console, 'log')
    gitr.ls('/Users/ken/dev/git/gitr/testDir')
    expect(console.log).toHaveBeenCalled()
    expect(console.log.callCount).toBe(2)
    expect(console.log.calls[0].args[0]).toBe('/Users/ken/dev/git/gitr/testDir/withGitRepo')
    expect(console.log.calls[1].args[0]).toBe('/Users/ken/dev/git/gitr/testDir/withGitRepoAtSecondLevel/secondLevel')

  it 'should have function for executing a git command', ->
    expect(gitr.do).toBeDefined()
    expect(cp.exec).toBeDefined();
    spyOn(cp, 'exec');
    gitr.do 'status', '/Users/ken/dev/git/gitr'
    expect(cp.exec).toHaveBeenCalled()
    expect(cp.exec.callCount).toBe(1)
    command = 'git --git-dir=/Users/ken/dev/git/gitr/.git --work-tree=/Users/ken/dev/git/gitr status'
    expect(cp.exec.calls[0].args[0]).toBe(command)

  it 'should execute git command at cmd if path is not supplied', ->
    expect(gitr.do).toBeDefined()
    expect(cp.exec).toBeDefined();
    spyOn(cp, 'exec');
    gitr.do 'status'
    expect(cp.exec).toHaveBeenCalled()
    expect(cp.exec.callCount).toBe(1)
    command = 'git --git-dir=/Users/ken/dev/git/gitr/.git --work-tree=/Users/ken/dev/git/gitr status'
    expect(cp.exec.calls[0].args[0]).toBe(command)

  it 'should execute git command recursively for all git enabled repos', ->
    expect(gitr.do).toBeDefined()
    expect(cp.exec).toBeDefined();
    spyOn(cp, 'exec').andCallFake (cmd, cb) -> cb()
    gitr.do 'status', 'testDir'
    expect(cp.exec).toHaveBeenCalled()
    expect(cp.exec.callCount).toBe(2)
    expect(cp.exec.calls[0].args[0]).toBe('git --git-dir=testDir/withGitRepoAtSecondLevel/secondLevel/.git --work-tree=testDir/withGitRepoAtSecondLevel/secondLevel status')
    expect(cp.exec.calls[1].args[0]).toBe('git --git-dir=testDir/withGitRepo/.git --work-tree=testDir/withGitRepo status')


