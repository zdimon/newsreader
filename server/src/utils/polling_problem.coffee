http = require 'http'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require('request');
log = require('winston-color')
log.level = process.env.LOG_LEVEL
easyimg = require 'easyimage'
requestSync = require('sync-request');
queue = require './polling_queue'
Stream = require('stream').Transform

get_data = (id)->
    dest = path.join(global.app_root,global.app_config.data_dir, "problem_journal.json")
    jsondata = JSON.parse(fs.readFileSync dest, 'utf8')
    fs.writeFileSync dest, JSON.stringify([]) 
    return jsondata

   
setAsProblem = (item)->
    done_path = path.join global.app_root, global.app_config.data_dir, 'problem_journal.json'
    jsondata = fs.readFileSync done_path, 'utf-8'        
    jsondata = JSON.parse(jsondata)
    jsondata.push item
    fs.writeFileSync done_path, JSON.stringify(jsondata)      
                    

process_queue = (lst,clb)->
    #console.log lst
    if lst.length == 0
        clb()
        return
    url = lst[0].uri
    
    log.debug "PROBLEMS QUEUE:  process #{lst[0].type}"
    
 
    if lst[0].type in ['article-image', 'cover', 'page', 'page-thumb']
        log.debug "PROBLEMS QUEUE:  request #{lst[0].type} #{url}"
        

        req = http.get(url,(res)->
            out = new Stream()
            res.on 'data', (chunk)-> #collect data
                out.push chunk
            res.on 'end', ()->
                console.log ('end request') 
                fs.writeFileSync lst[0].path, out.read()
                lst.splice 0, 1
                process_queue lst, clb
        )
        req.on 'socket', (socket)-> # Timeout
            socket.setTimeout 30000
            socket.on 'timeout', ()->
                req.abort()
                lst.splice 0, 1
                process_queue lst, clb
        req.on 'error', (err)->
            if err.code == 'ECONNRESET'
                log.error 'Timeout'
                setAsProblem(lst[0])
    else               
        lst.splice 0, 1
        process_queue lst, clb                    
                  


process_problem = (clb)->
    log.debug "Process with problems..."
    jsondata = get_data()
    process_queue jsondata, ()->
        console.log 'Done!' 
        clb()      



out =
    process_problem: process_problem

module.exports = out
