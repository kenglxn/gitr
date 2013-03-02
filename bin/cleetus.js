#!/usr/bin/env node

var path = require('path');
var fs = require('fs');
var coffee = require("coffee-script")

require(path.join(__dirname, '../lib/cleetus.coffee'));