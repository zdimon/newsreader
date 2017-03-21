polling = require 'async-polling'
http = require 'http'
global.remote_host = 'pressa.ru'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'


makeresponse = (options, onResult)->
    dest = path.join(global.app_root, global.app_config.data_dir, "top10/#{utils.getNowDate()}.json")
    fs.stat dest, (err,stat)-> #only if the file does not exist
        if err != null
            console.log('Requesting....')
            http.get(options,(res)->
                out = ''
                res.on 'data', (chunk)-> #collect data
                    out = out + chunk
                res.on 'end', ()->
                    fs.writeFile dest, out, (err)-> # write to disk
                        if err
                            console.log(err)
                        console.log "The file #{dest} was saved!"
                    onResult(res.statusCode,out) #apply callback
            )



get_top_from_remote = (end)->
    options =
      host: global.remote_host,
      path: "/mts/api/top10/#{utils.getNowDate()}.json"
    makeresponse(options, (code,res)->
        console.log "Request is compleated with code #{code}"
    )
    end()

get_top_from_remote ()-> #invoke gettop function


poolling =
    get_top_from_remote: get_top_from_remote

module.exports = poolling #export for using outside

#polling(gettop, 3000).run() #periodically invocation
