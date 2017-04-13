http = require 'http'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require('request');
issue = require './polling_issues'
log = require('winston-color')
log.level = process.env.LOG_LEVEL
log.debug "Importing polling pages module"

read_catalog = (path,clb)->
    fs.readFile path, 'utf8', (err,data)->
        if err
            clb(null,"#{err}")
        else
            clb(JSON.parse(data))
      
process_pages = (pages)->
    count = 0
    issue_path = path.join global.app_root, global.app_config.data_dir, "journals/#{pages.journal_id}/#{pages.issue_id}/thumbnail_done.dat"
    if !fs.existsSync issue_path
        for pk,pv of pages.pages
            count = count + 1
            im_url = "http://#{global.remote_host}#{pv.cover}"
            console.log im_url
            image_path = path.join global.app_root, global.app_config.data_dir, "journals/#{pages.journal_id}/#{pages.issue_id}/thumbnails/#{pv.number}.jpg"
            request(im_url).pipe(fs.createWriteStream(image_path)).on 'close', ()->
                log.verbose "saved #{im_url}"        
            if count == parseInt(pages.check_sum)
                #console.log issue_path
                fs.writeFile issue_path, '', (err)->
                    if err
                        log.error err
            #console.log pv.number+'-'+count+'-'+pages.check_sum
              
process_issue = (issue)->
    url = "http://#{global.remote_host}/zd/#{issue.id}.json"
    issue_done_path = path.join global.app_root, global.app_config.data_dir, "journals/#{issue.journal_id}/#{issue.id}/thumbnail_done.dat"
    if !fs.existsSync issue_done_path
        req = http.get url,(res)->
            out = ''
            res.on 'data', (chunk)-> #collect data
                out = out + chunk
            res.on 'end', ()->
                process_pages JSON.parse(out)
        req.on 'socket', (socket)-> 
            socket.setTimeout 20000
            socket.on 'timeout', ()->
                req.abort()
        req.on 'error', (err)->
            if err.code == 'ECONNRESET'
                log.error "PAGES: timeout #{url}"

    
    
process_catalog = (clb)->
    log.debug "Process catalog"
    catalog_path = path.join(global.app_root, global.app_config.data_dir, "catalog/catalog.json")
    read_catalog catalog_path, (data, err)->
        if err
            clb("#{err}")
        else
            for k,v of data.categories
                for jk, jv of v.journals
                    for ik, iv of jv.issues
                        process_issue iv
            clb()
        

    
poolling =
    process_catalog: process_catalog
    process_issue: process_issue

module.exports = poolling #export for using outside
