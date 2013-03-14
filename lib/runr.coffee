argv = process.argv.slice(2)
argv[0] ?= 'help'

Cleetus = require './cleetus'
c = new Cleetus()
fn = c[argv[0]] ?= c['help'];
fn(argv.slice(1)...)
