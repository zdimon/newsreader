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

router.get '/gitpull', (req, res, next)->
    execute 'git pull', (rez,err)->
        res.end rez
        

router.get '/gitstatus', (req, res, next)->
    execute 'git status', (rez,err)->
        res.end rez
    

router.get '/build', (req, res, next)->
    execute './build.sh', (rez,err)->
        res.end rez
        
router.get '/npm', (req, res, next)->
    execute 'npm install', (rez,err)->
        res.end rez        
        
router.get '/update', (req, res, next)->
    execute './update.sh', (rez,err)->
        res.end rez         

router.get '/ok', (req, res, next)->
    res.end 'OK' 

module.exports = router 
