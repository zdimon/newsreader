express = require 'express'
router = express.Router()
utils = require '../utils/utils'
path = require 'path'
fs = require 'fs'
log = require('winston-color')
log.level = process.env.LOG_LEVEL


getArticlesFromFS = (offset=0)-> #get top 10 list from file
   
    date = utils.getNowDate(offset)
    
    #try ## if file exist
        #dest = path.join(global.app_root, global.app_config.data_dir, "catalog/#{date}.json")
    dest = path.join(global.app_root,'public','test', 'articles.json')
    cont = JSON.parse(fs.readFileSync dest, 'utf8')
    #catch
    #    offset = offset+1
    #    getArticlesFromFS(offset) 


router.get '/', (req, res, next)->
    try
        res.send(getArticlesFromFS())
    catch e
        log.error "Error geting catalog! #{e}"
        #polling.get_top_from_remote ()-> #get top 10 from the remote server
        #res.send {status: 1, message: e.message}


module.exports = router;
