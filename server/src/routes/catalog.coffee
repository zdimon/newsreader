express = require 'express'
router = express.Router()
utils = require '../utils/utils'
path = require 'path'
fs = require 'fs'
log = require('winston-color')
log.level = process.env.LOG_LEVEL

dest_pb =  path.join global.app_root, global.app_config.data_dir, 'problem_journal.json'
jsondata = JSON.parse(fs.readFileSync dest_pb, 'utf8')
console.log jsondata


getCatalogFromFS = ()-> #get top 10 list from file
   
    #date = utils.getNowDate(offset)
    #console.log jsondata
    #try ## if file exist
        #dest = path.join(global.app_root, global.app_config.data_dir, "catalog/#{date}.json")
    dest = path.join(global.app_root, global.app_config.data_dir, "catalog/catalog.json")
    cont = JSON.parse(fs.readFileSync dest, 'utf8')
    for k,v of cont.categories
        for jk, jv of v.journals
            if jv.id in jsondata
                delete cont.categories[k].journals[jv.id]
                
    return cont
        #console.log jsondata
    #catch

    #    offset = offset+1
    #    getCatalogFromFS(offset)


router.get '/', (req, res, next)->
    try
        res.send(getCatalogFromFS())
    catch e
        log.error "Error geting catalog! #{e}"
        #polling.get_top_from_remote ()-> #get top 10 from the remote server
        #res.send {status: 1, message: e.message}


module.exports = router;
