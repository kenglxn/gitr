Cleetus = require './cleetus'
c = new Cleetus()

args = process.argv.slice(2)

if args.length > 0
  c[args[0]](args.slice(1))
else
  c.help()
