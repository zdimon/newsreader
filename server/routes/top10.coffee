express = require 'express'
router = express.Router()
utils = require '../utils/utils'
path = require 'path'
fs = require 'fs'
polling = require '../utils/polling'


getTop10FromFS = (offset=0)-> #get top 10 list from file
    date = utils.getNowDate(offset)
    try ## if file exist
        dest = path.join(global.app_root, global.app_config.data_dir, "top10/#{date}.json")
        cont = JSON.parse(fs.readFileSync dest, 'utf8')
    catch
        offset = offset+1
        getTop10FromFS(offset)


router.get '/', (req, res, next)->
    try
        res.send(getTop10FromFS(date))
    catch
        try ## request for yesterday
            res.send(getTop10FromFS())
        catch e
            polling.get_top_from_remote ()-> #get top 10 from the remote server
            res.send {status: 1, message: e.message}


module.exports = router;
