express = require 'express'
router = express.Router()
utils = require '../utils/utils'
path = require 'path'
fs = require 'fs'
polling = require '../utils/polling'

getTop10FromFS = (date)->
    try ## if file exist
        dest = path.join(global.app_root, global.app_config.data_dir, "top10/#{date}.json")
        cont = JSON.parse(fs.readFileSync dest, 'utf8')
    catch
        throw new SyntaxError("TOP10 does not exist for #{date} !!!");

router.get '/', (req, res, next)->
    #get top 10 list from file
    date = utils.getNowDate()

    try
        res.send(getTop10FromFS(date))
    catch
        try ## request for yesterday
            date = utils.getNowDate(1)
            res.send(getTop10FromFS(date))
        catch e
            polling.get_top_from_remote ()-> #get top 10 from the remote server
            res.send {status: 1, message: e.message}


module.exports = router;
