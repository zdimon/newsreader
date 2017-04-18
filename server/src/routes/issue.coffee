express = require 'express'
router = express.Router()
utils = require '../utils/utils'
path = require 'path'
fs = require 'fs'
log = require('winston-color')
log.level = process.env.LOG_LEVEL


getIssueFromFS = (journal_id,issue_id)-> #get top 10 list from file
    
    try ## if file exist
        dest = path.join global.app_root, global.app_config.data_dir, "journals", "#{journal_id}", "#{issue_id}", 'info.json'
        cont = JSON.parse(fs.readFileSync dest, 'utf8')
        pages_path = path.join global.app_root, global.app_config.data_dir, "journals", "#{journal_id}", "#{issue_id}", 'pages.json'
        cont_pages = JSON.parse(fs.readFileSync pages_path, 'utf8')        
        out = {status: 0, info: cont, pages: cont_pages}
    catch e
        cont = {status: 1, error: 'Извините, информация отсутствует.', err: e} 


router.get '/:journal_id/:issue_id.json', (req, res, next)->
    log.debug 'hi'+req.params.journal_id
    try
        res.send(getIssueFromFS(req.params.journal_id,req.params.issue_id))
    catch e
        log.error "Error geting pages! #{e}"
        #polling.get_top_from_remote ()-> #get top 10 from the remote server
        #res.send {status: 1, message: e.message}


module.exports = router;
