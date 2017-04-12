express = require 'express'
router = express.Router()
utils = require '../utils/utils'
path = require 'path'
fs = require 'fs'
log = require('winston-color')
log.level = process.env.LOG_LEVEL


getArticlesFromFS = (journal_id,issue_id)-> #get top 10 list from file
    
    try ## if file exist
        dest = path.join global.app_root, global.app_config.data_dir, "articles", "#{journal_id}", "#{issue_id}", 'articles.json'
        cont = JSON.parse(fs.readFileSync dest, 'utf8')
    catch
        cont = {articles: { 1: {image: 'images/no.png', title: 'Извините, текстовая информация отсутствует.'}}}


router.get '/:journal_id/:issue_id.json', (req, res, next)->
    log.debug 'hi'+req.params.journal_id
    try
        res.send(getArticlesFromFS(req.params.journal_id,req.params.issue_id))
    catch e
        log.error "Error geting catalog! #{e}"
        #polling.get_top_from_remote ()-> #get top 10 from the remote server
        #res.send {status: 1, message: e.message}


module.exports = router;
