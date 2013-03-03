_ = require('underscore')._

class Cleetus
  error   = '\x1B[0;31m'
  info = '\x1B[0;32m'
  reset = '\x1B[0m'

  log = (msg, level) ->
    level ?= info
    console.log level + msg + reset

  ls: ->
    log 'ls()'

exports = module.exports = Cleetus