exec = require('child_process').exec
fs = require 'fs'
path = require('path');
log = require('winston-color')
log.level = process.env.LOG_LEVEL
global.app_config = require('./config')
global.app_root = path.resolve __dirname, '../..'

top = require './utils/polling_top10'
creator = require './utils/polling_creator'
problem = require './utils/polling_problem'
queue = require './utils/polling_queue'
cleaner = require './utils/cleaner'
problem = require './utils/polling_problem'

log.debug "Testing....#{global.app_root}"

###
page.process_catalog (err)->
    if err
        log.error "#{err}"
###

#Articles

#articles.get_articles_from_server()


#issue.check_issues()
#top.get_top10_from_server()
#articles.crop_images()
#problem.process_problem()
#catalog.get_catalog_from_server ()->

#articles.grab_articles()


###
creator.handle ()->
    log.debug 'Processor has finished a job!'
    queue.handle ()->
        log.debug 'Queue has finished a job!'
###

#creator.getNew()

#creator.handle ()->
#    log.debug 'Processor has finished a job!'
    
    
problem.process_problem ()->
    log.debug 'finished a job!'
