fs = require 'fs', _ = require 'underscore', cp = require 'child_process', color = require './color', q = require './q'

class GitR

  checkDirArg = (dirArg) -> if dirArg?.length then "#{dirArg}".replace /\/$/, '' else "#{process.cwd()}"
  log = (m...) => console.log m...

  findRepos = (dir) =>
    dirs = []
    if fs.statSync(dir).isDirectory()
      subDirs = fs.readdirSync(dir)
      if '.git' in subDirs
        dirs.push dir
      else
        _.each subDirs, (subDir) ->
          dirs.push findRepos dir + '/' + subDir
    _.flatten dirs

  exec = (gitCmd, repo, cb) =>
    cp.exec gitCmd, (err, stdout, stderr) ->
      msg = ''
      msg += "#{stdout}\n#{color.cls}" if stdout?.length > 0
      msg += "#{color.red}#{err}#{color.cls}" if err?.length > 0
      msg += "#{color.red}#{stderr}#{color.cls}" if stderr?.length > 0
      log "#{color.yellow}::#{repo}::#{color.green}\n#{msg}" if msg?.length > 0
      cb()

  ls: (dir) => _.each findRepos(checkDirArg(dir)), (repo) => log repo

  do: (cmd = '', path) =>
    fns = []
    dir = checkDirArg(path)
    repos = findRepos(dir)
    _.each repos, (repo) =>
      fns.push (cb) =>
        exec "git --git-dir=#{repo}/.git --work-tree=#{repo} #{cmd}", repo, cb
    q.dequeue fns, =>
    log "#{color.red}no git repos under #{color.yellow}#{dir}#{color.cls}" if repos.length == 0

exports = module.exports = GitR
