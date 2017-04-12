http = require 'http'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require('request');
log = require('winston-color')
log.level = process.env.LOG_LEVEL
log.debug "Importing polling articles module"  

#
#http://pressa.ru/zd/txt/101963.json

read_catalog = ()->
    try 
        dest = path.join(global.app_root, global.app_config.data_dir, "catalog/catalog.json")
        cont = JSON.parse(fs.readFileSync dest, 'utf8')
        return cont
    catch    
        return {code: 1, message: 'file does not exist!' }
    
get_and_save_article = (url,dest)->
    log.debug "ARTICLE: Start loading from#{url}"
    
    req = http.get(url,(res)->
        out = ''
        res.on 'data', (chunk)-> #collect data
            out = out + chunk
        res.on 'end', ()->
            jsdata = JSON.parse(out)
            fs.writeFile dest, out, (err)-> # write to disk
                if err
                    log.error(err)
                console.log "ARTICLE: End loading file #{dest} has been saved!"            
            #log.debug out
        )
         
    req.on 'socket', (socket)-> 
        socket.setTimeout 15000
        socket.on 'timeout', ()->
            req.abort()
    req.on 'error', (err)->
        if err.code == 'ECONNRESET'
            log.error "ARTICLE: timeout #{url}"
    

get_articles_from_server = ()->
    log.debug "ARTICLES: Start request from #{url}"
    log.debug "ARTICLES: rtead catalog"
    cat = read_catalog()
    loaded = []
    for k,v of cat.categories
        for jk, jv of v.journals
            for ik, iv of jv.issues
                if iv.has_articles
                    if iv.id not in loaded
                        url = "http://pressa.ru/zd/txt/#{iv.id}.json"
                        loaded.push iv.id
                        journal_dir = path.join global.app_root, global.app_config.data_dir, "articles", "#{iv.journal_id}"                       
                        if !fs.existsSync journal_dir
                            fs.mkdirSync journal_dir
                        issue_dir = path.join journal_dir, "#{iv.id}"                       
                        if !fs.existsSync issue_dir
                            fs.mkdirSync issue_dir
                        dest = path.join issue_dir, "articles.json"
                        if !fs.existsSync dest
                            get_and_save_article(url,dest)
                        
     
            

poolling =
    get_articles_from_server: get_articles_from_server

module.exports = poolling #export for using outside
