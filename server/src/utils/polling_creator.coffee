http = require 'http'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require('request');
log = require('winston-color')
log.level = process.env.LOG_LEVEL
log.debug "Importing polling creator module"
requestSync = require('sync-request');
queue = require './polling_queue'

###
    Function makes a request to server and pass json
    data to the callback function
###

done_path = path.join global.app_root, global.app_config.data_dir, 'done.json'

if !fs.existsSync done_path
    fs.writeFile(done_path, "")
    
donedata = fs.readFileSync done_path, 'utf-8'        
donedata = JSON.parse(donedata)
    

setArticles = (jsdata,isssue_out)->
    ###
    article_dir = path.join(global.app_root, global.app_config.data_dir, 'articles', "#{jsdata.journal_id}")
    if !fs.existsSync article_dir
        log.verbose "Creating #{article_dir}"
        fs.mkdirSync article_dir
    article_dir = path.join(article_dir, "#{jsdata.id}")
    if !fs.existsSync article_dir
        log.verbose "Creating #{article_dir}"
        fs.mkdirSync article_dir
    ###
    url = "http://pressa.ru/zd/txt/#{jsdata.id}.json"
    dest = path.join global.app_root, global.app_config.data_dir, "articles", "#{jsdata.journal_id}/#{jsdata.id}/articles.json"
    isssue_out.push(path: dest, uri: url, type: 'article-json')

    res = requestSync('GET', url)
    out = JSON.parse(res.getBody('utf8'))
    for k,v of out.articles
        pt = path.join global.app_root, global.app_config.data_dir, "articles", "#{jsdata.journal_id}/#{jsdata.id}/#{v.id}.jpg"
        isssue_out.push({type: 'article-image', path: pt, uri: v.square_image})
        pt = path.join global.app_root, global.app_config.data_dir, "articles", "#{jsdata.journal_id}/#{jsdata.id}/#{v.id}_big.jpg"
        isssue_out.push({type: 'article-image', path: pt, uri: v.image})
    return isssue_out

getCatalog = ()->
    log.debug 'Start process'
    url = 'http://pressa.ru/zd/catalog.json'
    log.debug "QUEUE CREATOR: get catalog from #{url}"
    dest = path.join(global.app_root,global.app_config.data_dir, "catalog", "catalog.json")
    res = requestSync('GET', url)
    if res.statusCode==200
        out = res.getBody('utf8')
        jsdata = JSON.parse(out)
        fs.writeFileSync dest, out
        return jsdata
    else
        return []
    

    
getCover = (jsdata)->
    image_path = path.join(global.app_root, global.app_config.data_dir, 'journals', "#{jsdata.journal_id}/#{jsdata.id}/cover.png")
    return {path: image_path, uri: jsdata.thumb, type: 'cover'}

getPagesJSON = (jsdata, url)->
    dest_pages = path.join(global.app_root, global.app_config.data_dir, 'journals', "#{jsdata.journal_id}/#{jsdata.id}","pages.json")

    return {path: dest_pages, uri: url, type: 'pages-json'}

    
getPages = (url,isssue_out, jsdata)->
    res = requestSync('GET', url)
    #issue_pages_path = path.join global.app_root, global.app_config.data_dir, "journals/#{jsdata.journal_id}/#{jsdata.id}/pages.json"
    #fs.writeFileSync issue_pages_path, res.getBody(), 'utf-8'
    jsdatapages = JSON.parse(res.getBody())
    for k,v of jsdatapages.pages
        pathp = path.join(global.app_root, global.app_config.data_dir, 'journals', "#{jsdata.journal_id}/#{jsdata.id}","thumbnails", "#{v.number}.jpeg")
        isssue_out.push({path: pathp, uri: "http://pressa.ru#{v.cover}", type: 'page-thumb'})
        im_url = "http://#{global.remote_host}/zd/page/#{v.id}/secretkey.json"
        pathp = path.join(global.app_root, global.app_config.data_dir, 'journals', "#{jsdata.journal_id}/#{jsdata.id}","pages", "#{v.number}.jpeg")
        isssue_out.push({path: pathp, uri: im_url, type: 'page'})
    return isssue_out
    



    
        
parseCatalog = (jsondata)->
    for k,v of jsondata.categories
        for jk, jv of v.journals
            for ik, iv of jv.issues
                if iv.id not in donedata
                    isssue_out = []
                    dest = path.join(global.app_root,global.app_config.data_dir, "queue", "#{iv.journal_id}-#{iv.id}.json")
                    if !fs.existsSync dest
                        if iv.has_articles
                            isssue_out = setArticles(iv,isssue_out)
                        url = "http://#{global.remote_host}/zd/#{iv.id}.json"               
                        isssue_out.push getCover(iv)
                        isssue_out.push getPagesJSON(iv,url)
                        isssue_out = getPages(url, isssue_out, iv) 
                        isssue_out.push {type: 'info', content: iv}
                        log.debug "QUEUE CREATOR: #{iv.journal_id}-#{iv.id}.json"
                        fs.writeFileSync dest, JSON.stringify(isssue_out)
                        #return
    
getNew = ()->
    dt = new Date()

    month = ('0' + (dt.getMonth() + 1)).slice(-2);
    date = ('0' + dt.getDate()).slice(-2);
    year = dt.getFullYear();    
    
    data = "#{year}-#{month}-#{date}"
    url = "http://#{global.remote_host}/static/api/zd/#{data}n.json"
    dest = path.join(global.app_root,global.app_config.data_dir, "new", "#{data}.json")
    res = requestSync('GET', url)
    fs.writeFileSync dest, res.getBody('utf8')
    
    
handle = (callback)->
    getNew()
    data = getCatalog()
    parseCatalog(data)    
    callback()


periodic_handle = (end)->
    handle ()->
        log.debug 'Creator has finished a job!'
        queue.handle ()->
            log.debug 'Queue has finished a job!'
            end()
        


poolling =
    handle: handle
    periodic_handle: periodic_handle
    getNew: getNew

module.exports = poolling #export for using outside
