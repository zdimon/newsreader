polling = require 'async-polling'
path = require 'path'
global.app_config = require('../config')
#require('../init')
global.app_root = path.resolve __dirname, '../../..'


queue = require './polling_queue'

top_polling =  polling(queue.handle_one, 60000*3)
top_polling.run() #periodically invocation



