Cleetus = require './cleetus'
c = new Cleetus()

args = process.argv.slice(2)

args[0] = 'help' if args.length == 0
c[args[0]](args.slice(1)...)
