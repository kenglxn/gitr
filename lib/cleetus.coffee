fs = require 'fs', _ = require 'underscore', cp = require 'child_process', color = require './color', q = require './q'

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

  exec = (gitCmd, repo, cb) =>
    cp.exec gitCmd, (err, stdout, stderr) ->
      msg = ''
      msg += "#{stdout}\n#{color.cls}" if stdout?.length > 0
      msg += "#{color.red}#{err}#{color.cls}" if err?.length > 0
      msg += "#{color.red}#{stderr}#{color.cls}" if stderr?.length > 0
      log "#{color.yellow}::#{repo}::#{color.green}\n#{msg}" if msg?.length > 0
      cb()

  help: =>
    log 'usage: cleetus <command> [<args>] [<base_path_of_execution>]\n'
    for fn of @
      log "> #{fn} :: #{doc[fn]}" unless fn is 'help'

  ls: (dir) => _.each repos(checkDirArg(dir)), (repo) => log repo

  do: (cmd = '', path) =>
    fns = []
    _.each repos(checkDirArg(path)), (repo) =>
      fns.push (cb) =>
        exec "git --git-dir=#{repo}/.git --work-tree=#{repo} #{cmd}", repo, cb
    q.dequeue fns, =>

exports = module.exports = Cleetus
