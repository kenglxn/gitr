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

  constructor: ->

  help: ->
    msg = 'Please supply a command. Available commands are:\n'
    for key of @
      msg += "\t#{key}\n"
    @log msg

  log: (msg, level = info) =>
    console.log level + msg + reset

  ls: (dir) =>
    _.each repos(checkDirArg(dir)), (repo) => @log repo

  do: (cmd, path) =>
    path = checkDirArg path
    _.each repos(checkDirArg(path)), (repo) =>
      cp.exec "git --git-dir=#{repo}/.git --work-tree=#{repo} #{cmd}"
#      @log repo


exports = module.exports = Cleetus