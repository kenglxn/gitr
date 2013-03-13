fs = require 'fs'
_ = require 'underscore'
cp = require 'child_process'

class Cleetus
  error  = '\x1B[0;31m'
  info = '\x1B[0;32m'
  reset = '\x1B[0m'

  checkDirArg = (dirArg) ->
    if dirArg?.length then "#{dirArg}".replace /\/$/, '' else "#{process.cwd()}"

  repos = (dir) =>
    dirs = []
    if fs.statSync(dir).isDirectory()
      subDirs = fs.readdirSync(dir)
      if '.git' in subDirs
        dirs.push dir
      else
        subDirs.every (subDir) ->
          dirs.push repos(dir + '/' + subDir)
    _.flatten dirs

  log = (msg, level = '') =>
    console.log level + msg
    console.log reset if level is not ''

  exec = (gitCmd) =>
    cp.exec gitCmd, (err, stdout, stderr) ->
      log err if err?
      log stdout if stdout?
      log stderr if stderr?

  definitions =
    'ls': "lists all repos"
    'do': "perform a git command in all repos known to ls"

  constructor: ->

  help: =>
    log 'Please supply a command. Available commands are:'
    for key of @
      log "> #{key} :: #{definitions[key]}" unless key is 'help'

  ls: (dir) =>
    _.each repos(checkDirArg(dir)), (repo) => log repo

  do: (cmd, path) =>
    path = checkDirArg path
    _.each repos(checkDirArg(path)), (repo) =>
      exec "git --git-dir=#{repo}/.git --work-tree=#{repo} #{cmd}"


exports = module.exports = Cleetus