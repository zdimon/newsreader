http = require 'http'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require('request');
issue = require './polling_issues'
log = require('winston-color')
log.level = process.env.LOG_LEVEL
log.debug "Importing polling pages module"

process_catalog = ()->
    log.debug "Process catalog"


process_issue = ()->
    log.debug "Process issue"
    
poolling =
    process_catalog: process_catalog
    process_issue: process_issue

module.exports = poolling #export for using outside
