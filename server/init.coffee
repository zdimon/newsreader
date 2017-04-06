exec = require('child_process').exec
fs = require 'fs'
path = require('path');
log = require('winston-color')
log.level = process.env.LOG_LEVEL
log.debug "Initialization...."

fs.lstat global.app_root+'/public/node_modules', (err, stats)->
    if err
        cmd = "ln -s "+global.app_root+"/node_modules public/node_modules"
        exec cmd, (err,stdout, stdin)->
            console.log(stdout)
            console.log('Create simlink on node_modules.....')

data_dir = path.join(global.app_root, global.app_config.data_dir)
top10_dir = path.join data_dir, 'top10'
top10_image_dir = path.join data_dir, 'top10', 'images'
journal_dir = path.join(global.app_root, global.app_config.data_dir, 'journals')

# create data dir

if !fs.existsSync data_dir
    log.info 'Creating data dir......'
    fs.mkdirSync data_dir


if !fs.existsSync top10_dir
    log.info 'Creating top10_dir ......'
    fs.mkdirSync top10_dir

if !fs.existsSync top10_image_dir
    log.info 'Creating top10_image_dir ......'
    fs.mkdirSync top10_image_dir

if !fs.existsSync journal_dir
    log.info 'Creating journal_dir ......'
    fs.mkdirSync journal_dir

# create tasks.json
fileName = 'tasks.json'
fs.exists fileName, (exists)->
    if not exists
        console.log 'Not exist!!'
        data = JSON.stringify([{"load_top_10": "loadTop10"}])
        console.log data
        fs.writeFile fileName, data, (err)->
            if err
                console.log err
