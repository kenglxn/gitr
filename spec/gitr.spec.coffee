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
    'testDir/withGitRepo/withGitRepoLvl2',
    'testDir/withGitRepo/withGitRepoLvl2/.git',
    'testDir/withGitRepoAtSecondLevel',
    'testDir/withGitRepoAtSecondLevel/secondLevel',
    'testDir/withGitRepoAtSecondLevel/secondLevel/.git',
  ]
  origDir = process.cwd()
  testDir = 'testDir'

  beforeEach ->
    for directory in directoryStructure
        unless fs.existsSync(directory)
          fs.mkdirSync(directory)
          fs.writeFileSync(directory + '/tmpFile', 'stuff') if directory.search('.git$') == -1
    process.chdir(testDir)

  afterEach ->
    process.chdir(origDir)
    rimraf.sync testDir

  it 'should execute git command recursively for all git enabled repos', ->
    expect(gitr.do).toBeDefined()
    expect(cp.spawn).toBeDefined();
    spyOn(cp, 'spawn').andCallFake (cmd, opts) ->
      on: (evt, cb)->
        cb()
    gitr.do 'status'
    expect(cp.spawn).toHaveBeenCalled()
    expect(cp.spawn.callCount).toBe(3)
    expect(cp.spawn.calls[0].args[0]).toBe("git")
    expect(cp.spawn.calls[0].args[1]).toEqual(["--git-dir=#{process.cwd()}/withGitRepoAtSecondLevel/secondLevel/.git", "--work-tree=#{process.cwd()}/withGitRepoAtSecondLevel/secondLevel" , "status"])
    expect(cp.spawn.calls[1].args[0]).toBe("git")
    expect(cp.spawn.calls[1].args[1]).toEqual(["--git-dir=#{process.cwd()}/withGitRepo/withGitRepoLvl2/.git", "--work-tree=#{process.cwd()}/withGitRepo/withGitRepoLvl2", "status"])
    expect(cp.spawn.calls[2].args[0]).toBe("git")
    expect(cp.spawn.calls[2].args[1]).toEqual(["--git-dir=#{process.cwd()}/withGitRepo/.git", "--work-tree=#{process.cwd()}/withGitRepo", "status"])

  it 'should support splats', ->
    expect(gitr.do).toBeDefined()
    expect(cp.spawn).toBeDefined();
    spyOn(cp, 'spawn').andCallFake (cmd, opts) ->
      on: (evt, cb)->
        cb()
    gitr.do 'diff', '--staged'
    expect(cp.spawn).toHaveBeenCalled()
    expect(cp.spawn.callCount).toBe(3)
    expect(cp.spawn.calls[0].args[0]).toBe("git")
    expect(cp.spawn.calls[0].args[1]).toEqual(["--git-dir=#{process.cwd()}/withGitRepoAtSecondLevel/secondLevel/.git", "--work-tree=#{process.cwd()}/withGitRepoAtSecondLevel/secondLevel" , "diff", "--staged"])
    expect(cp.spawn.calls[1].args[0]).toBe("git")
    expect(cp.spawn.calls[1].args[1]).toEqual(["--git-dir=#{process.cwd()}/withGitRepo/withGitRepoLvl2/.git", "--work-tree=#{process.cwd()}/withGitRepo/withGitRepoLvl2", "diff", "--staged"])
    expect(cp.spawn.calls[2].args[0]).toBe("git")
    expect(cp.spawn.calls[2].args[1]).toEqual(["--git-dir=#{process.cwd()}/withGitRepo/.git", "--work-tree=#{process.cwd()}/withGitRepo", "diff", "--staged"])
