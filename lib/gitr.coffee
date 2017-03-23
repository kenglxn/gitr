fs = require 'fs', _ = require 'underscore', cp = require 'child_process', color = require './color', q = require './q'

class GitR
  log = (m...) => console.log m...

  findRepos = (dir = process.cwd()) =>
    dirs = []
    if fs.statSync(dir).isDirectory()
      subDirs = fs.readdirSync(dir)
      if '.git' in subDirs
        dirs.push dir

      _.each subDirs, (subDir) ->
        dirs.push findRepos dir + '/' + subDir
    _.flatten dirs

  exec = (cmd, repo, cb) =>
    log "#{color.yellow}:: #{repo} ::#{color.cls}"
    child = cp.spawn 'git', _.flatten(["--git-dir=#{repo}/.git", "--work-tree=#{repo}", cmd]),
      stdio: 'inherit'
    child.on 'exit', cb

  do: (cmd...) =>
    fns = []
    repos = findRepos()
    _.each repos, (repo) => fns.push (cb) => exec cmd, repo, cb
    q.dequeue fns, =>
    log "#{color.red}no git repos under #{color.yellow}#{process.cwd()}#{color.cls}" if repos.length == 0

exports = module.exports = GitR
