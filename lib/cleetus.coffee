fs = require 'fs'

class Cleetus
  error   = '\x1B[0;31m'
  info = '\x1B[0;32m'
  reset = '\x1B[0m'

  constructor: ->
    console.log "duhr ima Cleetus.. yerp.."

  log: (msg, level = info) =>
    console.log level + msg + reset

  ls: (dir) ->
    directories = fs.readdirSync(dir)
    isGitDir = false
    for file in directories
      isGitDir = true if file == '.git'
    if !isGitDir
      for subDir in directories
        @ls dir + '/' + subDir
    else
      @log dir

exports = module.exports = Cleetus