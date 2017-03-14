# Workflow

## Initialization

    npm init
    npm install bootstrap --save
    npm install angular --save
    npm install jquery --save


    express


###Main template loyout.jade

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
<<<<<<< HEAD
=======


>>>>>>> edc10f2c4a12533e63630a585975bce947cc13db
