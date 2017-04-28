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
issue = require './polling_issues'
catalog = require './polling_catalog'

process_problem = ()->
    log.debug "Process with problems..."
    path_to_problems = path.join global.app_root, global.app_config.data_dir, "problem_issue.json"
    cont = JSON.parse(fs.readFileSync path_to_problems, 'utf8')
    for i in cont
        console.log i
        #issue_file = path.join(global.app_root, global.app_config.data_dir, 'journals', "#{jsdata.journal_id}")
    
        #catalog
        #log.verbose "ARTICLE PB: Working with #{i.journal_id}-#{i.id}"
        #dest_done = path.join global.app_root, global.app_config.data_dir, "articles", "#{i.journal_id}/#{i.id}/done.dat"
        #if fs.existsSync dest_done
        #    fs.unlinkSync dest_done
        #article.process_queue_articles([{journal_id: i.journal_id, id: i.id}])

out =
    process_problem: process_problem

module.exports = out