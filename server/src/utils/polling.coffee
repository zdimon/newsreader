polling = require 'async-polling'
path = require 'path'
global.app_config = require('../config')
#require('../init')
global.app_root = path.resolve __dirname, '../../..'


##############Importing pooling modules#########

top10 = require './polling_top10'
creator = require './polling_creator'
cleaner = require './cleaner'
problem = require './polling_problem'



##########Imploing pooling services##############

##########Issue###########
#issue_polling =  polling(issue.process_issues, 60000*30)
#issue_polling.run() #periodically invocation

##########Top 10##########
top_polling =  polling(top10.get_top10_from_server, 60000*600)
top_polling.run() #periodically invocation



##########Top 10 portal##########
top_polling_portal =  polling(top10.get_top10_portal_from_server, 60000*30)
top_polling_portal.run() #periodically invocation


#setTimeout top10.get_top10_from_server, 1000


##########Catalog#########
#catalog_polling =  polling(catalog.get_catalog_from_server, 60000*30)
#catalog_polling.run() #periodically invocation


##########Creator#########
creator =  polling(creator.periodic_handle, 60000*720)
creator.run() #periodically invocation


##########Cleaner#########
cleaner =  polling(cleaner.process_cleaning, 60000*60*24)
cleaner.run() #periodically invocation


##########Problem#########
problem =  polling(problem.process_problem, 60000*60*24)
problem.run() #periodically invocation


##########Article#########
#article_polling =  polling(problem.process_problem, 60000*30)
#article_polling.run() #periodically invocation

