http = require 'http'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require('request');
log = require('winston-color')
log.level = process.env.LOG_LEVEL
log.debug "Importing polling articles module"  
requestSync = require('sync-request');
easyimg = require 'easyimage'
inspector = require './polling_inspector'
    
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
    #console.log lst
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
                crop_image({journal_id: i.journal_id, id: i.id})
                try
                    cont = JSON.parse(fs.readFileSync dest, 'utf8')
                    fs.writeFileSync dest_done, "1" 
                catch
                     process_queue_articles(lst)
                       
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
     
crop_images = ()->     
    log.verbose "ARTICLE: cropping images"
    cat = read_catalog()
    loaded = []
    for k,v of cat.categories
        for jk, jv of v.journals
            for ik, iv of jv.issues
                if iv.has_articles
                    loaded.push iv
    for i,v of loaded
       crop_image v
    
crop_image = (jsondata)->
    log.verbose "ARTICLE: cropping process #{jsondata.id}"
    path_to_json = path.join global.app_root, global.app_config.data_dir, "articles", "#{jsondata.journal_id}/#{jsondata.id}/articles.json"
    log.debug path_to_json
    #try
    cont = JSON.parse(fs.readFileSync path_to_json, 'utf8')
    for i,v of cont.articles
        path_to_image = path.join global.app_root, global.app_config.data_dir, "articles", "#{jsondata.journal_id}/#{jsondata.id}/#{v.id}.png"
        path_to_image_crop = path.join global.app_root, global.app_config.data_dir, "articles", "#{jsondata.journal_id}/#{jsondata.id}/#{v.id}.png"
        opt = {
            src: path_to_image,
            dst: path_to_image_crop,
            x: 0,
            y:0,
            cropwidth:80,
            cropheight:80
        }                
        easyimg.crop(opt).then (file)->
            log.debug "Image croped #{file.width}x#{file.height}"
        , (err)->
            console.log err
            #console.log v.id 
        #console.log cont
    #catch e
    #    log.error "Invalid json #{e} issue #{jsondata.id}"
        #write_problems(jsondata.id, jsondata.journal_id)

  
write_problems = (id,journal_id)->
    path_to_problems = path.join global.app_root, global.app_config.data_dir, "articles", "problems.json"
    if !fs.existsSync path_to_problems
        fs.writeFileSync path_to_problems, '[]', 'utf-8'
    cont = JSON.parse(fs.readFileSync path_to_problems, 'utf8')
    el = {journal_id: journal_id, id: id}
    if el not in cont
        cont.push el
        fs.writeFileSync path_to_problems, JSON.stringify(cont), 'utf-8'
       
       
###############################        
 

create_list_of_issues = (clb)->
    log.debug "Creating list of issues...."
    issues = []
    path_to_catalog = path.join(global.app_root, global.app_config.data_dir, "catalog/catalog.json")
    
    fs.readFile path_to_catalog, 'utf-8', (err,data)->
        if err
            
            clb(null,err)
        else
            try
                
                cont = JSON.parse data
                
                for k,v of cont.categories
                    for jk, jv of v.journals
                        for ik, iv of jv.issues
                            if iv.has_articles
                                if iv.id not in issues
                                    issues.push {journal_id:iv.journal_id, id: iv.id}                
                clb(issues)
            catch e
                clb(null, e)
                
make_http_request = (url,clb)->
    log.debug "Making HTTP async request to #{url}"
    
    req = http.get(url,(res)->
        out = ''
        res.on 'data', (chunk)-> #collect data
            out = out + chunk
        res.on 'end', ()->
                clb(out)
        )
         
    req.on 'socket', (socket)-> 
        socket.setTimeout 20000
        socket.on 'timeout', ()->
            req.abort()
    req.on 'error', (err)->
        if err.code == 'ECONNRESET'
            log.error "ARTICLE: timeout #{url}"
            clb(null,"Timeout error")
              
              
create_dirs = (journal_id,issue_id,clb)->
    journal_dir = path.join global.app_root, global.app_config.data_dir, "articles", "#{journal_id}"                       
    if !fs.existsSync journal_dir
        fs.mkdirSync journal_dir 
    issue_dir = path.join journal_dir, "#{issue_id}"                       
    if !fs.existsSync issue_dir
        fs.mkdirSync issue_dir                
        



proc_save_json_to_disk = (lst,clb)->     
    log.debug "ARTICLES: saving json"
    
    proc_dwn_images = (lst,clb)->
        dwn_image = (lst)->
            if lst[0]
                log.debug lst[0].url
                request(lst[0].url).pipe(fs.createWriteStream(lst[0].image_path)).on 'close', ()->
                    lst.splice 0, 1
                    dwn_image(lst)                   
            
            else
                clb()
        dwn_image(lst)    
    
    save_json_to_disk = (lst)->
        if lst[0]
            #check if already downloaded
            if inspector.is_done({object:"articles", id: lst[0].id})
                lst.splice 0, 1
                save_json_to_disk(lst)
            else
                url = "http://pressa.ru/zd/txt/#{lst[0].id}.json"
                make_http_request url, (data,err)->
                    if err
                        log.error "TIMEOUT ERROR repeat request"
                        save_json_to_disk(lst)
                    else
                        try
                            jsdata = JSON.parse(data)
                            dest = path.join global.app_root, global.app_config.data_dir, "articles", "#{lst[0].journal_id}/#{lst[0].id}/articles.json"
                            create_dirs(lst[0].journal_id,lst[0].id)
                            fs.writeFile dest, JSON.stringify(jsdata), 'utf-8', (err)->
                                if err
                                    log.error err
                                images_small = []     
                                for i in jsdata.articles
                                    image_path = path.join global.app_root, global.app_config.data_dir, "articles", "#{i.journal_id}", "#{i.issue_id}", "#{i.id}.png"
                                    images_small.push {
                                        image_path : image_path
                                        url: i.square_image
                                    }
                                    
                                images_big = []     
                                for i in jsdata.articles
                                    image_path = path.join global.app_root, global.app_config.data_dir, "articles", "#{i.journal_id}", "#{i.issue_id}", "#{i.id}_big.png"
                                    images_big.push {
                                        image_path : image_path
                                        url: i.image
                                    }
                               
                                proc_dwn_images images_small, ()->
                                    proc_dwn_images images_big, ()->
                                        inspector.mark_as_done({object: "article", id: lst[0].id})
                                        lst.splice 0, 1
                                        save_json_to_disk(lst)
                        catch
                            log.error "JSON parse error, repeat request"
                            save_json_to_disk(lst)
        else
            clb(lst)
    
    save_json_to_disk(lst)
    
 
 
grab_articles = ()->
    log.debug "Grabbing articles..."
    create_list_of_issues (data,err)->
        if err
            log.error "ARTICLE ERROR: #{err}"
        else
            #save_json_to_disk data
            lst_for_json = data.slice()
            lst_for_images = data.slice()
            proc_save_json_to_disk lst_for_json, ()->
                #proc_save_image_to_disk lst_for_images, ()->
                #    log.debug "Finished"
        
    
    
poolling =
    get_articles_from_server: get_articles_from_server
    get_and_save_article: get_and_save_article
    process_queue_articles: process_queue_articles
    crop_images: crop_images
    grab_articles: grab_articles

module.exports = poolling #export for using outside
