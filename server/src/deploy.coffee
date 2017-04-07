Client = require('ssh2').Client
fs = require 'fs'
conn = new Client()
conn.on 'ready', () ->
	console.log('Client :: ready')
	conn.exec 'cd newsreader; git pull', (err,stream)->
		if err
			console.log err
		stream.on 'end', ()->
			conn.end()
		.on 'data', (data)->
			console.log data.toString()
.connect
	host: 'webmonstr.com',
	port: 22,
	username: 'zdimon',
	privateKey: require('fs').readFileSync('/home/zdimon/.ssh/id_rsa')
