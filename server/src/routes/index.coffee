express = require 'express'
router = express.Router()

# GET home page.
router.get '/', (req, res, next)->
    res.render 'layout',
        title: 'ТОП 10'

execSync = require('child_process').execSync
spawn = require('child_process').spawn

exec = require('child_process').exec;
execute = (command, callback)->
    exec command, (error, stdout, stderr)->
        callback(stdout,stderr)


router.get '/git', (req, res, next)->
    execute 'git status', (rez,err)->
        res.end rez
    

        

module.exports = router
