http = require 'http'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require('request');
log = require('winston-color')
log.level = process.env.LOG_LEVEL
log.debug "Importing pooling top 10 module" 
easyimg = require 'easyimage'
requestSync = require('sync-request');

makeresponse = (options, onResult)->
    dest = path.join(global.app_root, global.app_config.data_dir, "top10/#{utils.getNowDate()}.json")
    fs.stat dest, (err,stat)-> #only if the file does not exist
        if err != null
            console.log('Requesting....')
            req = http.get(options,(res)->
                out = ''
                res.on 'data', (chunk)-> #collect data
                    out = out + chunk
                res.on 'end', ()->
                    jsdata = JSON.parse(out)
                    download_image(jsdata)
                    if parseInt(Object.keys(jsdata.articles).length) > 9
                        fs.writeFile dest, out, (err)-> # write to disk
                            if err
                                log.error(err)
                            console.log "The file #{dest} was saved!"
                    onResult(res.statusCode,out) #apply callback
            )
            req.on 'socket', (socket)-> # Timeout
                socket.setTimeout 10000
                socket.on 'timeout', ()->
                    req.abort()
            req.on 'error', (err)->
                if err.code == 'ECONNRESET'
                    console.log 'Timeour occurs'




get_top10_from_server = (end)->
    log.debug "TOP10: start"
    options =
      host: global.remote_host,
      path: "/mts/api/top10/#{utils.getNowDate()}.json"
    makeresponse(options, (code,res)->
        console.log "Request is compleated with code #{code}"
    )
    end()
    

download_image = (jsdata)->
    date_dir =  path.join(global.app_root, global.app_config.data_dir, 'top10','images',jsdata.date)
    image_date_dir =  path.join(global.app_root, global.app_config.data_dir, 'top10','images')
    
    if !fs.existsSync image_date_dir
        log.verbose "debug", "Creating #{image_date_dir}"
        fs.mkdirSync image_date_dir    
    
    if !fs.existsSync date_dir
        log.verbose "debug", "Creating #{date_dir}"
        fs.mkdirSync date_dir 
            
        
    for i in jsdata.articles
    
        image_path = path.join(date_dir,"#{i.id}.png")
        image_path_crop = path.join(date_dir,"#{i.id}_crop.png")
        
        res = requestSync('GET', i.small_image)
        fs.writeFileSync image_path, res.getBody() 
        
        res = requestSync('GET', i.small_image_square)
        fs.writeFileSync image_path_crop, res.getBody()        
        
        log.verbose "saved #{i.small_image}"
        ###
        opt = {
            src: image_path,
            dst: image_path_crop,
            x: 0,
            y:0,
            cropwidth:80,
            cropheight:80
        }                
        easyimg.crop(opt).then (file)->
            log.debug "Image croped #{file.width}x#{file.height}"
        , (err)->
            console.log err
        ###
       
               
                



getTop10FromFS = (offset=0)-> #get top 10 list from file
    date = utils.getNowDate(offset)
    try ## if file exist
        dest = path.join(global.app_root, global.app_config.data_dir, "top10/#{date}.json")
        #console.log dest
        cont = JSON.parse(fs.readFileSync dest, 'utf8')
    catch
        offset = offset+1
        getTop10FromFS(offset)
        
        

crop = ()->
    log.debug "Cropping"
    jsdata = getTop10FromFS()
    date = jsdata.date
    for i,v of jsdata.articles
        path_img = path.join global.app_root, global.app_config.data_dir, "top10/images/#{date}/#{v.id}.png"
        path_img_crop = path.join global.app_root, global.app_config.data_dir, "top10/images/#{date}/#{v.id}_crop.png"
        opt = {
            src: path_img,
            dst: path_img,
            x: 0,
            y:0,
            cropwidth:80,
            cropheight:80
        }
        easyimg.crop(opt).then (file)->
            log.debug "Imege croped #{file.width}x#{file.height}"
        , (err)->
            console.log err
        console.log path_img

out =
    get_top10_from_server: get_top10_from_server
    crop: crop

module.exports = out
