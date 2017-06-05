http = require 'http'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require('request');
log = require('winston-color')
log.level = process.env.LOG_LEVEL
easyimg = require 'easyimage'
requestSync = require('sync-request');
rimraf = require 'rimraf'
glob = require 'glob' 


get_catalog = (id)->
    dest = path.join(global.app_root,global.app_config.data_dir, "catalog", "catalog.json")
    jsondata = JSON.parse(fs.readFileSync dest, 'utf8')
    catalog = {}
    console.log "Process "
    for k,v of jsondata.categories
        for jk, jv of v.journals
            if  not catalog[parseInt(jv.id)]
                catalog[parseInt(jv.id)] = []
            for ik, iv of jv.issues
                if iv.id not in catalog[parseInt(jv.id)]
                    catalog[parseInt(jv.id)].push iv.id
    #console.log catalog
    return catalog
    

process_cleaning = (clb)->
    log.debug "CLEANER: starting..."
    for k,v of get_catalog()
        pt = path.join(global.app_root,global.app_config.data_dir, "journals", k)
        #console.log pt
        fs.readdirSync(pt).forEach (file)->
            #console.log v
            if parseInt(file) not in v
                pathdel = path.join pt, file
                rimraf pathdel, ()->
                    log.debug "Removing #{pathdel}"
                pathdel = path.join global.app_root,global.app_config.data_dir, "articles", k, file
                rimraf pathdel, ()->
                    log.debug "Removing #{pathdel}"                

        #for issue in v
        #    console.log issue
    clb()
   

out =
    process_cleaning: process_cleaning

module.exports = out
