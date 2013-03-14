fs = require 'fs'
_ = require 'underscore'
cp = require 'child_process'
cls = '\x1B[0m'
red  = '\x1B[0;31m'
green = '\x1B[0;32m'
yellow = '\x1B[0;33m'

class Cleetus
  doc =
    'ls': "lists all repos"
    'do': "perform a git command in all repos known to ls"

  checkDirArg = (dirArg) -> if dirArg?.length then "#{dirArg}".replace /\/$/, '' else "#{process.cwd()}"

  log = (m...) => console.log m...

  repos = (dir) =>
    dirs = []
    if fs.statSync(dir).isDirectory()
      subDirs = fs.readdirSync(dir)
      if '.git' in subDirs
        dirs.push dir
      else
        _.each subDirs, (subDir) ->
          dirs.push repos dir + '/' + subDir
    _.flatten dirs

  exec = (gitCmd, repo) =>
    cp.exec gitCmd, (err, stdout, stderr) ->
      msg = ''
      msg += "#{stdout}\n#{cls}" if stdout?.length > 0
      msg += "#{red}#{err}#{cls}" if err?.length > 0
      msg += "#{red}#{stderr}#{cls}" if stderr?.length > 0
      log "#{yellow}::#{repo}::#{green}\n#{msg}" if msg?.length > 0

  help: =>
    log 'Available commands:'
    for fn of @
      log "> #{fn} :: #{doc[fn]}" unless fn is 'help'

  ls: (dir) => _.each repos(checkDirArg(dir)), (repo) => log repo

  do: (cmd = '', path) =>
    path = checkDirArg path
    _.each repos(checkDirArg(path)), (repo) =>
      exec "git --git-dir=#{repo}/.git --work-tree=#{repo} #{cmd}", repo

exports = module.exports = Cleetus
