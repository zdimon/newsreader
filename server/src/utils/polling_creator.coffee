http = require 'http'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require('request');
log = require('winston-color')
log.level = process.env.LOG_LEVEL
log.debug "Importing polling creator module"
requestSync = require('sync-request');

###
    Function makes a request to server and pass json
    data to the callback function
###

setArticles = (jsdata,isssue_out)->
    article_dir = path.join(global.app_root, global.app_config.data_dir, 'articles', "#{jsdata.journal_id}")
    if !fs.existsSync article_dir
        log.verbose "Creating #{article_dir}"
        fs.mkdirSync article_dir
    article_dir = path.join(article_dir, "#{jsdata.id}")
    if !fs.existsSync article_dir
        log.verbose "Creating #{article_dir}"
        fs.mkdirSync article_dir
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
    
setIssueJSON = (jsdata)->
    journal_dir = path.join(global.app_root, global.app_config.data_dir, 'journals', "#{jsdata.journal_id}")
    
    if !fs.existsSync journal_dir
        log.verbose "Creating #{journal_dir}"
        fs.mkdirSync journal_dir
    issue_dir = path.join(journal_dir, "#{jsdata.id}")
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
        cont = fs.writeFileSync dest, JSON.stringify(jsdata)

    
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
        isssue_out.push({path: pathp, uri: v.cover, type: 'page-small'})
        im_url = "http://#{global.remote_host}/zd/page/#{v.id}/secretkey.json"
        pathp = path.join(global.app_root, global.app_config.data_dir, 'journals', "#{jsdata.journal_id}/#{jsdata.id}","pages", "#{v.number}.jpeg")
        isssue_out.push({path: pathp, uri: im_url, type: 'page-big'})
    return isssue_out
    
        
parseCatalog = (jsondata)->
    for k,v of jsondata.categories
        for jk, jv of v.journals
            for ik, iv of jv.issues
                isssue_out = []
                if iv.has_articles
                    isssue_out = setArticles(iv,isssue_out)
                setIssueJSON(iv)
                url = "http://#{global.remote_host}/zd/#{iv.id}.json"               
                isssue_out.push getCover(iv)
                isssue_out.push getPagesJSON(iv)
                isssue_out = getPages(url, isssue_out, iv) 
                dest = path.join(global.app_root,global.app_config.data_dir, "queue", "#{iv.journal_id}-#{iv.id}.json")
                log.debug "QUEUE CREATOR: #{iv.journal_id}-#{iv.id}.json"
                fs.writeFileSync dest, JSON.stringify(isssue_out)
                #return
    
    
handle = (callback)->
    data = getCatalog()
    parseCatalog(data)    
    callback()



poolling =
    handle: handle

module.exports = poolling #export for using outside
