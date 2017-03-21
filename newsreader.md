# Workflow

## Initialization

    npm init
    npm install bootstrap --save
    npm install angular --save
    npm install jquery --save


    express


### Main template loyout.jade

    doctype html
    html
        head
            meta(charset="utf-8")
            meta(http-equiv="X-UA-Compatible" content="IE=edge")
            meta(name="viewport" content="width=device-width, initial-scale=1")            
            title= title
            link(rel='stylesheet', href='/stylesheets/style.css')
            link(rel='stylesheet', href='node_modules/bootstrap/dist/css/bootstrap.min.css')
            script(src='node_modules/jquery/dist/jquery.min.js')
            script(src='node_modules/angular/angular.min.js')
            script(src='node_modules/angular-ui-router/release/angular-ui-router.min.js')
            script(src='node_modules/bootstrap/dist/js/bootstrap.min.js')
        body(ng-app='readerApp')
            block content



### Creating simlink on node_modules

    var exec = require('child_process').exec;
    var fs = require('fs');

    fs.lstat(__dirname+'/public/node_modules', function(err, stats) {
        if(err) {
            cmd = "ln -s "+__dirname+"/node_modules public/node_modules"
            exec(cmd, function(err,stdout, stdin){
                        console.log(stdout)
                        console.log('create simlink')
                    }
                )
            }
        });   







### Minifycations


    npm install gulp  --save-dev
    npm install gulp-concat --save-dev
    npm install gulp-uglify --save-dev



    ///gulpfile.js

    console.log('Start');

    var concat = require('gulp-concat');
    var gulp = require('gulp');
    var uglify = require('gulp-uglify');


    gulp.task('default', function() {
      gulp.src(['./app.js', './ctrl.js'])
        .pipe(concat('all.js'))
        .pipe(uglify())
        .pipe(gulp.dest('./dist/'))
    });


#### Watchers


    var appjs = [
                 './public/javascripts/app.js',
                 './public/javascripts/controller.js',
                 './public/javascripts/router.js'
                ]

    gulp.task('default', function() {
      gulp.src(appjs)
        .pipe(concat('app.min.js'))
        .pipe(uglify())
        .pipe(gulp.dest('./public/dist'))
    });


    gulp.task('watch', function () {
        gulp.watch('public/**/*.js', ['default']);
    });


> Running commands simultaneously.

    npm install concurrently --save-dev  

    "watch": "concurrently --kill-others 'coffee -cw -o public/javascripts reader' 'jade -w -o public/templates reader' 'gulp watch'"

## Configuration  (server/config.coffee)

    module.exports =
        host: 'pressa.ru'
        data_dir: 'data'

## Initialization *server/init.coffee*

It applies one time after starting our server.


    exec = require('child_process').exec
    fs = require 'fs'
    path = require('path');


    fs.lstat global.app_root+'/public/node_modules', (err, stats)->
        if err
            cmd = "ln -s "+global.app_root+"/node_modules public/node_modules"
            exec cmd, (err,stdout, stdin)->
                console.log(stdout)
                console.log('Create simlink on node_modules.....')

    data_dir = path.join(global.app_root, global.app_config.data_dir)
    top10_dir = path.join data_dir, 'top10'


    # create data dir

    if !fs.existsSync data_dir
        console.log 'Creating data dir......'
        fs.mkdirSync data_dir


    if !fs.existsSync top10_dir
        console.log 'Creating top10_dir ......'
        fs.mkdirSync top10_dir


## Global variables **server/serverApp.js**

    global.app_config = require('./server/config');
    global.app_root = __dirname;
    require('./server/init');
    ....

## Utilites (date function)


*server/utils/utils.coffee*


    module.exports =
        getNowDate: ()->
            today = new Date()
            dd =  today.getDate()
            if dd<10
                dd='0'+dd
            mm = today.getMonth()+1
            if mm<10
                mm='0'+mm
            "#{today.getFullYear()}-#{mm}-#{dd}"


## Poling module (utils/polling.coffee).

    polling = require 'async-polling'
    http = require 'http'
    global.remote_host = 'pressa.ru'
    fs = require 'fs'
    path = require 'path'
    utils = require '../utils/utils'


    makeresponse = (options, onResult)->
        dest = path.join(global.app_root, global.app_config.data_dir, "top10/#{utils.getNowDate()}.json")
        fs.stat dest, (err,stat)-> #only if the file does not exist
            if err != null
                console.log('Requesting....')
                http.get(options,(res)->
                    out = ''
                    res.on 'data', (chunk)-> #collect data
                        out = out + chunk
                    res.on 'end', ()->
                        fs.writeFile dest, out, (err)-> # write to disk
                            if err
                                console.log(err)
                            console.log "The file #{dest} was saved!"
                        onResult(res.statusCode,out) #apply callback
                )



    get_top_from_remote = (end)->
        options =
          host: global.remote_host,
          path: "/mts/api/top10/#{utils.getNowDate()}.json"
        makeresponse(options, (code,res)->
            console.log "Request is compleated with code #{code}"
        )
        end()

    get_top_from_remote ()-> #invoke gettop function


    poolling =
        get_top_from_remote: get_top_from_remote

    module.exports = poolling #export for using outside

    #polling(gettop, 3000).run() #periodically invocation



## Populating top 10 *server/routes/top10.coffee*.


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


Use this router in serverApp.js


    var top10 = require('./server/routes/top10');
    .....
    app.use('/top10', top10);


