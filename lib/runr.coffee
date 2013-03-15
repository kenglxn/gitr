argv = process.argv.slice(2)

GitR = require './gitr'
gitr = new GitR()
gitr.do argv...
