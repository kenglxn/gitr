Cleetus = require './cleetus'
c = new Cleetus()

args = process.argv.slice(2)

if args.length == 0
  c.log 'Missing command, please supply a command.'
  c.log 'Available commands are:'
  for key of c
    c.log "  #{key}"
else
  c[args[0]](args.slice(1))