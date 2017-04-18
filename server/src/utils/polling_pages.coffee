http = require 'http'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require('request');
issue = require './polling_issues'
log = require('winston-color')
log.level = process.env.LOG_LEVEL
log.debug "Importing polling pages module"
requestSync = require('sync-request');

read_catalog = (path,clb)->
    fs.readFile path, 'utf8', (err,data)->
        if err
            clb(null,"#{err}")
        else
            clb(JSON.parse(data))
            
         
            
process_big_pages = (pages)->
    count = 0
    issue_path = path.join global.app_root, global.app_config.data_dir, "journals/#{pages.journal_id}/#{pages.issue_id}/thumbnail_done.dat"
    for pk,pv of pages.pages
        count = count + 1
        im_url = "http://#{global.remote_host}/zd/page/#{pv.id}/secretkey.json"
        log.debug im_url 
        log.verbose "PAGES: saving... #{pages.journal_id}-#{pages.issue_id}-#{pv.number} big page"
        image_path = path.join global.app_root, global.app_config.data_dir, "journals/#{pages.journal_id}/#{pages.issue_id}/pages/#{pv.number}.jpg"
        res = requestSync('GET', im_url)
        fs.writeFileSync image_path, res.getBody()
        #request(im_url).pipe(fs.createWriteStream(image_path)).on 'close', ()->
        #    log.verbose "saved #{im_url}"        
        if count == parseInt(pages.check_sum)
            #console.log issue_path
            fs.writeFileSync issue_path, ''    
      
process_pages = (pages)->
    issue_path = path.join global.app_root, global.app_config.data_dir, "journals/#{pages.journal_id}/#{pages.issue_id}/thumbnail_done.dat"
    for pk,pv of pages.pages
        count = count + 1
        im_url = "http://#{global.remote_host}#{pv.cover}"
        log.verbose "PAGES: saving... #{pages.journal_id}-#{pages.issue_id}-#{pv.number} page"
        image_path = path.join global.app_root, global.app_config.data_dir, "journals/#{pages.journal_id}/#{pages.issue_id}/thumbnails/#{pv.number}.jpg"
        res = requestSync('GET', im_url)
        fs.writeFileSync image_path, res.getBody()
    process_big_pages(pages)
              
process_issue = (issue)->
    url = "http://#{global.remote_host}/zd/#{issue.id}.json"
    issue_done_path = path.join global.app_root, global.app_config.data_dir, "journals/#{issue.journal_id}/#{issue.id}/thumbnail_done.dat"
    if !fs.existsSync issue_done_path
    #console.log issue
        res = requestSync('GET', url)
        process_pages JSON.parse(res.getBody())
  

save_page_json = (issue)->
    url = "http://#{global.remote_host}/zd/#{issue.id}.json"
    res = requestSync('GET', url)
    issue_pages_path = path.join global.app_root, global.app_config.data_dir, "journals/#{issue.journal_id}/#{issue.id}/pages.json"
    fs.writeFileSync issue_pages_path, res.getBody(), 'utf-8'
    log.info "PAGES: saving JSON  #{issue_pages_path}"
    
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
    save_page_json: save_page_json

module.exports = poolling #export for using outside
