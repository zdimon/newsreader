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

if !fs.existsSync data_dir
    console.log 'Creating data dir......'
    fs.mkdirSync data_dir


if !fs.existsSync top10_dir
    console.log 'Creating top10_dir ......'
    fs.mkdirSync top10_dir
