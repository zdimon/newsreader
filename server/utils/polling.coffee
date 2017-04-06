polling = require 'async-polling'
http = require 'http'
global.remote_host = 'pressa.ru'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require 'request'
log = require('winston-color')
log.level = process.env.LOG_LEVEL


##############Importing pooling modules#########
catalog = require './polling_catalog'
issue = require './polling_issues'
top10 = require './polling_top10'



##########Imploing pooling services##############

##########Issue###########
issue_polling =  polling(issue.process_issues, 60000*30)
issue_polling.run() #periodically invocation

##########Top 10##########
top_polling =  polling(top10.get_top10_from_server, 60000*30)
top_polling.run() #periodically invocation

##########Catalog#########
catalog_polling =  polling(catalog.get_catalog_from_server, 60000*30)
catalog_polling.run() #periodically invocation



