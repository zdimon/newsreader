express = require 'express'
router = express.Router()
utils = require '../utils/utils'
path = require 'path'
fs = require 'fs'
polling = require '../utils/polling'



router.get '/', (req, res, next)->
    #get top 10 list from file
    dest = path.join(global.app_root, global.app_config.data_dir, "top10/#{utils.getNowDate()}.json")

    try ## if file exist
        num = fs.statSync dest
        cont = JSON.parse(fs.readFileSync dest, 'utf8')
        res.send(cont)
    catch
        polling.get_top_from_remote ()-> #get top 10 from the remote server
        res.send {status: 1, message 'top 10 does not exist'}


module.exports = router;
