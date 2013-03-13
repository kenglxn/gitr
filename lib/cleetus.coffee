fs = require 'fs'
_ = require 'underscore'
cp = require 'child_process'

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

  exec = (gitCmd) =>
    cp.exec gitCmd, (err, stdout, stderr) ->
      log err if err?
      log stdout if stdout?
      log stderr if stderr?

  help: =>
    log 'Available commands:'
    for fn of @
      log "> #{fn} :: #{doc[fn]}" unless fn is 'help'

  ls: (dir) => _.each repos(checkDirArg(dir)), (repo) => log repo

  do: (cmd, path) =>
    path = checkDirArg path
    _.each repos(checkDirArg(path)), (repo) =>
      exec "git --git-dir=#{repo}/.git --work-tree=#{repo} #{cmd}"

exports = module.exports = Cleetus