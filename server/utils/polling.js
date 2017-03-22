// Generated by CoffeeScript 1.11.1
(function() {
  var fs, get_top_from_remote, http, makeresponse, path, polling, poolling, utils;

  polling = require('async-polling');

  http = require('http');

  global.remote_host = 'pressa.ru';

  fs = require('fs');

  path = require('path');

  utils = require('../utils/utils');

  makeresponse = function(options, onResult) {
    var dest;
    dest = path.join(global.app_root, global.app_config.data_dir, "top10/" + (utils.getNowDate()) + ".json");
    return fs.stat(dest, function(err, stat) {
      if (err !== null) {
        console.log('Requesting....');
        return http.get(options, function(res) {
          var out;
          out = '';
          res.on('data', function(chunk) {
            return out = out + chunk;
          });
          return res.on('end', function() {
            fs.writeFile(dest, out, function(err) {
              if (err) {
                console.log(err);
              }
              return console.log("The file " + dest + " was saved!");
            });
            return onResult(res.statusCode, out);
          });
        });
      }
    });
  };

  get_top_from_remote = function(end) {
    var options;
    options = {
      host: global.remote_host,
      path: "/mts/api/top10/" + (utils.getNowDate()) + ".json"
    };
    makeresponse(options, function(code, res) {
      return console.log("Request is compleated with code " + code);
    });
    return end();
  };

  get_top_from_remote(function() {});

  poolling = {
    get_top_from_remote: get_top_from_remote
  };

  module.exports = poolling;

}).call(this);