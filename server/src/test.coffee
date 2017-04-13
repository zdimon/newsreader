exec = require('child_process').exec
fs = require 'fs'
path = require('path');
log = require('winston-color')
log.level = process.env.LOG_LEVEL
global.app_config = require('./config')
global.app_root = path.resolve __dirname, '../..'
page = require './utils/polling_pages'
log.debug "Testing....#{global.app_root}"

page.process_catalog (err)->
    if err
        log.error "#{err}"


