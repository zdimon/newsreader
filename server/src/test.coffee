exec = require('child_process').exec
fs = require 'fs'
path = require('path');
log = require('winston-color')
log.level = process.env.LOG_LEVEL
global.app_config = require('./config')
global.app_root = path.resolve __dirname, '../..'
page = require './utils/polling_pages'
articles = require './utils/polling_articles'
catalog = require './utils/polling_catalog'
issue = require './utils/polling_issues'
top = require './utils/polling_top10'
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
#rticles.crop_images()
problem.process_problem()
#catalog.get_catalog_from_server()  