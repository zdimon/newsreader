// Generated by CoffeeScript 1.9.3
(function() {
  var Client, conn, fs;

  Client = require('ssh2').Client;

  fs = require('fs');

  conn = new Client();

  conn.on('ready', function() {
    console.log('Client :: ready');
    return conn.exec('cd newsreader; git pull', function(err, stream) {
      if (err) {
        console.log(err);
      }
      return stream.on('end', function() {
        return conn.end();
      }).on('data', function(data) {
        return console.log(data.toString());
      });
    });
  }).connect({
    host: 'webmonstr.com',
    port: 22,
    username: 'zdimon',
    privateKey: require('fs').readFileSync('/home/zdimon/.ssh/id_rsa')
  });

}).call(this);
