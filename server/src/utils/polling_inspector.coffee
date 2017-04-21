fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'

log = require('winston-color')
log.level = process.env.LOG_LEVEL
log.debug "Importing polling inspector module"  


inspector_log = path.join global.app_root, global.app_config.data_dir, 'inspector.json'

if !fs.existsSync inspector_log
    data = {
        articles: [],
        issues: {},
        pages:{},
        top10: {},
    }
    fs.writeFileSync inspector_log, JSON.stringify(data), 'utf-8'
        
inspector_data = fs.readFileSync inspector_log, 'utf-8'        
inspector_json_data = JSON.parse(inspector_data)

console.log inspector_json_data

#{ object: 'article', type: 'json', id: 102214 }

mark_as_done = (obj)->
    
    if obj.object == 'article'
        inspector_json_data.articles.push obj.id
        fs.writeFileSync inspector_log, JSON.stringify(inspector_json_data), 'utf-8'
   
    
is_done = (obj)->
    if obj.id in inspector_json_data[obj.object]
        return true
    else
        return false
    
    
    
poolling =
    mark_as_done: mark_as_done
    is_done: is_done
module.exports = poolling #export for using outside
