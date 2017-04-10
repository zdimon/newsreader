http = require 'http'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require('request');
log = require('winston-color')
log.level = process.env.LOG_LEVEL
log.debug "Importing polling catalog module"

get_catalog_from_server = ()->

    url = 'http://pressa.ru/zd/catalog.json'
    log.debug "CATALOG: Start request from #{url}"

    req = http.get(url,(res)->
        out = ''
        res.on 'data', (chunk)-> #collect data
            out = out + chunk
        res.on 'end', ()->
            jsdata = JSON.parse(out)
            dest = path.join(global.app_root,global.app_config.data_dir, "catalog", "catalog.json")
            fs.writeFile dest, out, (err)-> # write to disk
                if err
                    log.error(err)
                console.log "The file #{dest} has been saved!"            
            #log.debug out
        )
         
    req.on 'socket', (socket)-> 
        socket.setTimeout 15000
        socket.on 'timeout', ()->
            req.abort()
    req.on 'error', (err)->
        if err.code == 'ECONNRESET'
            log.error 'Timeout occurs!!'
            


poolling =
    get_catalog_from_server: get_catalog_from_server

module.exports = poolling #export for using outside
