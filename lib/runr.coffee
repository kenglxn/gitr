argv = process.argv.slice(2)

GitR = require './gitr'
new GitR().do argv...
