polling = require 'async-polling'
http = require 'http'
global.remote_host = 'pressa.ru'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'




makeresponse = (options, onResult)->
    dest = path.join(global.app_root, global.app_config.data_dir, "top10/#{utils.getNowDate()}.json")
    fs.stat dest, (err,stat)->
        if err != null
            console.log('Requesting....')

            http.get(options,(res)->
                out = ''
                res.on 'data', (chunk)->
                    out = out + chunk
                res.on 'end', ()->
                    #out = JSON.parse(out)

                    fs.writeFile dest, out, (err)->
                        if err
                            console.log(err)
                        console.log "The file was saved!"
                    onResult(res.statusCode,out)
            )



gettop = (end)->
    console.log 'getting top 10'
    options =
      host: global.remote_host,
      path: "/mts/api/top10/#{utils.getNowDate()}.json"
    makeresponse(options, (code,res)->
        console.log(code)
    )
    end()

gettop ()->
    console.log 'Done!'


poolling =
    grabtop: gettop

module.exports = poolling

#polling(gettop, 3000).run()
