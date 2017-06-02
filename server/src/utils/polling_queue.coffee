http = require 'http'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require('request');
log = require('winston-color')
log.level = process.env.LOG_LEVEL
log.debug "Importing polling issue module"  
requestSync = require('sync-request');

    
#
#http://pressa.ru/zd/txt/101963.json

getIssueFile = ()->
    dest = path.join(global.app_root,global.app_config.data_dir, "queue")
    files = []
    fs.readdirSync(dest).forEach (file) -> 
        files.push(file)
    if files.lenght > 0
        destf = path.join dest, files[0]
    else
        return []
    return destf

handle = (clb)->
    console.log 'Go'
    jsondata = getIssueFile()
    console.log jsondata
    clb()
        
    
    
poolling =
    handle: handle


module.exports = poolling #export for using outside
