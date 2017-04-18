express = require 'express'
router = express.Router()
utils = require '../utils/utils'
path = require 'path'
fs = require 'fs'


getTop10FromFS = (offset=0)-> #get top 10 list from file
    date = utils.getNowDate(offset)
    try ## if file exist
        dest = path.join(global.app_root, global.app_config.data_dir, "top10/#{date}.json")
        console.log dest
        cont = JSON.parse(fs.readFileSync dest, 'utf8')
    catch
        offset = offset+1
        getTop10FromFS(offset)


router.get '/', (req, res, next)->
    try
        res.send(getTop10FromFS(date))
    catch
        res.send {status: 1, message: 'Top 10 is empty!'}


module.exports = router;
