http = require 'http'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require('request');
log = require('winston-color')
log.level = process.env.LOG_LEVEL
easyimg = require 'easyimage'
requestSync = require('sync-request');
article = require './polling_articles'

process_problem = ()->
    log.debug "Process with problems..."
    path_to_problems = path.join global.app_root, global.app_config.data_dir, "articles", "problems.json"
    cont = JSON.parse(fs.readFileSync path_to_problems, 'utf8')
    for i in cont
        log.verbose "ARTICLE PB: Working with #{i.journal_id}-#{i.id}"
        url = "http://pressa.ru/zd/txt/#{iv.id}.json"

out =
    process_problem: process_problem

module.exports = out