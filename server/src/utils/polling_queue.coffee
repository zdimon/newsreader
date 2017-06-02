http = require 'http'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require('request');
log = require('winston-color')
log.level = process.env.LOG_LEVEL
log.debug "Importing polling issue module"  
requestSync = require('sync-request');
Stream = require('stream').Transform
    
#
#http://pressa.ru/zd/txt/101963.json

get_issue = (id)->
    dest = path.join(global.app_root,global.app_config.data_dir, "catalog", "catalog.json")
    jsondata = JSON.parse(fs.readFileSync dest, 'utf8')
    for k,v of jsondata.categories
        for jk, jv of v.journals
            for ik, iv of jv.issues
                if iv.id = id
                    return iv
    return null
    

process_dirs = (file)->
    arr = file.split('.')
    jar = arr[0].split('-')
    journal_id = jar[0]
    issue_id = jar[1]
    
    # check if issue is in the catalog
    issue = get_issue(issue_id)
    if not issue
        return false
    
    setAsDone(issue_id)
    
    journal_dir = path.join(global.app_root, global.app_config.data_dir, 'journals', "#{journal_id}")   
    if !fs.existsSync journal_dir
        log.verbose "Creating #{journal_dir}"
        fs.mkdirSync journal_dir
        
    issue_dir = path.join(journal_dir, "#{issue_id}")
    if !fs.existsSync issue_dir
        log.verbose "Creating #{issue_dir}"
        fs.mkdirSync issue_dir
        
    issue_page_dir = path.join(issue_dir,"pages")
    if !fs.existsSync issue_page_dir
        log.verbose "Creating #{issue_page_dir}"
        fs.mkdirSync issue_page_dir
        
    issue_covers_dir = path.join(issue_dir,"thumbnails")
    if !fs.existsSync issue_covers_dir
        log.verbose "Creating #{issue_covers_dir}"
        fs.mkdirSync issue_covers_dir
    


    dest = path.join(issue_dir,"info.json")
    
    if !fs.existsSync dest 
        cont = fs.writeFileSync dest, JSON.stringify(issue)    
    
    if issue.has_articles
        article_dir = path.join(global.app_root, global.app_config.data_dir, 'articles', "#{journal_id}")
        if !fs.existsSync article_dir
            log.verbose "Creating #{article_dir}"
            fs.mkdirSync article_dir
        article_dir = path.join(article_dir, "#{issue_id}")
        if !fs.existsSync article_dir
            log.verbose "Creating #{article_dir}"
            fs.mkdirSync article_dir        
    
    return true

process_test = (lst)->
    if lst.length == 0
        return
    console.log lst
    lst.splice 0, 1
    process_test lst



setAsDone = (issue_id)->
    done_path = path.join global.app_root, global.app_config.data_dir, 'done.json'
    jsondata = fs.readFileSync done_path, 'utf-8'        
    jsondata = JSON.parse(jsondata)
    if issue_id not in jsondata
        jsondata.push parseInt(issue_id)
        fs.writeFileSync done_path, JSON.stringify(jsondata)
    
process_queue = (lst,clb)->
    #console.log lst
    if lst.length == 0
        clb()
        return
    url = lst[0].uri
    log.debug "TASK QUEUE:  request #{lst[0].type} #{url}"
    
    
    
    if lst[0].type in ['article-image', 'cover', 'page', 'page-thumb']
        log.debug "TASK QUEUE:  request #{lst[0].type} #{url}"
        
        if url == 'http://pressa.ru/static/article/img/art_cover.png'
            dest = path.join(global.app_root, 'public', 'images', 'art_cover.png')
            fs.writeFileSync(lst[0].path, fs.readFileSync(dest))
            lst.splice 0, 1
            process_queue lst, clb
        else
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
                socket.setTimeout 15000
                socket.on 'timeout', ()->
                    req.abort()
                    lst.splice 0, 1
                    process_queue lst, clb
            req.on 'error', (err)->
                if err.code == 'ECONNRESET'
                    log.error 'Timeout'
    else if lst[0].type in ['article-json', 'pages-json', 'page']
        log.debug "TASK QUEUE:  request json #{url}"
        req = http.get(url,(res)->
            out = ''
            res.on 'data', (chunk)-> #collect data
                out = out + chunk
            res.on 'end', ()->
                fs.writeFileSync lst[0].path, JSON.stringify(out)
                lst.splice 0, 1
                process_queue lst, clb
        )
        req.on 'socket', (socket)-> # Timeout
            socket.setTimeout 15000
            socket.on 'timeout', ()->
                req.abort()
                lst.splice 0, 1
                process_queue lst, clb
        req.on 'error', (err)->
            if err.code == 'ECONNRESET'
                log.error 'Timeout!!!'
    else
        lst.splice 0, 1
        process_queue lst, clb
    
                    
    

getIssueFile = ()->
    dest = path.join(global.app_root,global.app_config.data_dir, "queue")
    files = []
    fs.readdirSync(dest).forEach (file) -> 
        files.push(file)
    if files.length > 0
        destf = path.join dest, files[0]
        cont = JSON.parse(fs.readFileSync destf, 'utf8')
        if not process_dirs(files[0])
            return []
        fs.unlinkSync destf
        return cont
    else
        return false
    return destf


    

handle = (clb)->
    console.log 'Go'
    jsondata = getIssueFile()
    if jsondata
        process_queue jsondata, ()->
            handle(clb)       
    else
        clb()
        
    #process_test [1,2,3]
        
    
    
poolling =
    handle: handle


module.exports = poolling #export for using outside
