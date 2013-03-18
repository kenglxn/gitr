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
    expect(cp.exec).toBeDefined();
    spyOn(cp, 'exec').andCallFake (cmd, cb) -> cb()
    gitr.do 'status'
    expect(cp.exec).toHaveBeenCalled()
    expect(cp.exec.callCount).toBe(2)
    expect(cp.exec.calls[0].args[0]).toBe("git --git-dir=#{process.cwd()}/withGitRepoAtSecondLevel/secondLevel/.git --work-tree=#{process.cwd()}/withGitRepoAtSecondLevel/secondLevel status")
    expect(cp.exec.calls[1].args[0]).toBe("git --git-dir=#{process.cwd()}/withGitRepo/.git --work-tree=#{process.cwd()}/withGitRepo status")

  it 'should support splats', ->
    expect(gitr.do).toBeDefined()
    expect(cp.exec).toBeDefined();
    spyOn(cp, 'exec').andCallFake (cmd, cb) -> cb()
    gitr.do 'diff', '--staged'
    expect(cp.exec).toHaveBeenCalled()
    expect(cp.exec.callCount).toBe(2)
    expect(cp.exec.calls[0].args[0]).toBe("git --git-dir=#{process.cwd()}/withGitRepoAtSecondLevel/secondLevel/.git --work-tree=#{process.cwd()}/withGitRepoAtSecondLevel/secondLevel diff --staged")
    expect(cp.exec.calls[1].args[0]).toBe("git --git-dir=#{process.cwd()}/withGitRepo/.git --work-tree=#{process.cwd()}/withGitRepo diff --staged")



