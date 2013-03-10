fs = require 'fs'

class Cleetus
  error  = '\x1B[0;31m'
  info = '\x1B[0;32m'
  reset = '\x1B[0m'

  constructor: ->

  log: (msg, level = info) =>
    console.log level + msg + reset

  ls: (dir) ->
    dir = process.cwd() unless dir?.length
    if fs.statSync(dir).isDirectory()
      subDirs = fs.readdirSync(dir)
      if '.git' in subDirs
        @log dir
      else
        for subDir in subDirs
          @ls(dir + '/' + subDir)


exports = module.exports = Cleetus