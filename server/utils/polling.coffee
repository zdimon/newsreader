polling = require 'async-polling'
http = require 'http'
global.remote_host = 'pressa.ru'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require('request');

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
                                console.log(err)
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




get_top_from_remote = (end)->
    options =
      host: global.remote_host,
      path: "/mts/api/top10/#{utils.getNowDate()}.json"
    makeresponse(options, (code,res)->
        console.log "Request is compleated with code #{code}"
    )
    end()

download_image = (jsdata)->
    date_dir =  path.join(global.app_root, global.app_config.data_dir, 'top10','images',jsdata.date)
    if !fs.existsSync date_dir
        console.log "Creating #{date_dir}"
        fs.mkdirSync date_dir
    for i in jsdata.articles
        image_path = path.join(date_dir,"#{i.id}.png")
        console.log i.small_image
        request(i.small_image).pipe(fs.createWriteStream(image_path)).on 'close', ()->
            console.log "saved #{i.small_image}"


#get_top_from_remote ()-> #invoke gettop function




top_polling =  polling(get_top_from_remote, 60000*30)
top_polling.run() #periodically invocation

poolling =
    get_top_from_remote: get_top_from_remote

module.exports = poolling #export for using outside
