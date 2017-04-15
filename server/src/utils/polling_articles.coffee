http = require 'http'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require('request');
log = require('winston-color')
log.level = process.env.LOG_LEVEL
log.debug "Importing polling articles module"  
requestSync = require('sync-request');

#
#http://pressa.ru/zd/txt/101963.json

read_catalog = ()->
    try 
        dest = path.join(global.app_root, global.app_config.data_dir, "catalog/catalog.json")
        cont = JSON.parse(fs.readFileSync dest, 'utf8')
        return cont
    catch    
        return {code: 1, message: 'file does not exist!' }
    
download_images = (jsdata)->
    try
        jsdata = JSON.parse(jsdata)
    catch
        log.error "Wrong json"
        console.log jsdata
        return
    for i in jsdata.articles
        image_path = path.join global.app_root, global.app_config.data_dir, "articles", "#{i.journal_id}", "#{i.issue_id}", "#{i.id}.png"
        res = requestSync('GET', i.small_image)
        fs.writeFileSync image_path, res.getBody()
        image_pathb = path.join global.app_root, global.app_config.data_dir, "articles", "#{i.journal_id}", "#{i.issue_id}", "#{i.id}_big.png"
        res = requestSync('GET', i.image)
        fs.writeFileSync image_pathb, res.getBody()
        log.debug "ARTICLE: Image saved #{i.id}"
    
          
    
get_and_save_article = (url,dest,callback)->
    log.debug "ARTICLE: Start loading from #{url}"
    
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
                callback(jsdata)
        )
         
    req.on 'socket', (socket)-> 
        socket.setTimeout 30000
        socket.on 'timeout', ()->
            req.abort()
    req.on 'error', (err)->
        if err.code == 'ECONNRESET'
            log.error "ARTICLE: timeout #{url}"
    

manage_with_dirs = (issue)->
    journal_dir = path.join global.app_root, global.app_config.data_dir, "articles", "#{issue.journal_id}"                       
    if !fs.existsSync journal_dir
        fs.mkdirSync journal_dir
    issue_dir = path.join journal_dir, "#{issue.id}"                       
    if !fs.existsSync issue_dir
        fs.mkdirSync issue_dir

process_queue_articles = (lst)->
    if lst.length == 0
        return
    for i in lst
        index = lst.indexOf(i);
        if index > -1
            dest_done = path.join global.app_root, global.app_config.data_dir, "articles", "#{i.journal_id}/#{i.id}/done.dat"
            if !fs.existsSync dest_done
                manage_with_dirs(i)
                url = "http://pressa.ru/zd/txt/#{i.id}.json"
                log.debug "ARTICLE: loading #{url}"
                res = requestSync('GET', url)
                out = res.getBody('utf8')
                dest = path.join global.app_root, global.app_config.data_dir, "articles", "#{i.journal_id}/#{i.id}/articles.json"
                fs.writeFileSync dest, out, 'utf-8'
                console.log "ARTICLE: file #{dest} has been saved!"
                download_images(out)
                now = new Date()
                fs.writeFileSync dest_done, "1"            
            lst.splice index, 1            
            process_queue_articles(lst)

            
            


get_articles_from_server = ()->
    log.debug "ARTICLES: Reading catalog"
    cat = read_catalog()
    loaded = []
    for k,v of cat.categories
        for jk, jv of v.journals
            for ik, iv of jv.issues
                if iv.has_articles
                    if iv.id not in loaded
                        url = "http://pressa.ru/zd/txt/#{iv.id}.json"
                        loaded.push iv
    process_queue_articles(loaded)
    ###
        dest = path.join issue_dir, "articles.json"
        if !fs.existsSync dest
            get_and_save_article url,dest, (jsdata)->
                download_images(jsdata)
    ###
     
            

poolling =
    get_articles_from_server: get_articles_from_server
    get_and_save_article: get_and_save_article

module.exports = poolling #export for using outside
