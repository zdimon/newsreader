express = require 'express'
router = express.Router()

# GET home page.
router.get '/', (req, res, next)->
    res.render 'layout',
        title: 'ТОП 10'


module.exports = router
