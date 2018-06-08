// Generated by CoffeeScript 1.9.3
(function() {
  var data, fs, inspector_data, inspector_json_data, inspector_log, is_done, log, mark_as_done, path, poolling, utils,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  fs = require('fs');

  path = require('path');

  utils = require('../utils/utils');

  log = require('winston-color');

  log.level = process.env.LOG_LEVEL;

  log.debug("Importing polling inspector module");

  inspector_log = path.join(global.app_root, global.app_config.data_dir, 'inspector.json');

  if (!fs.existsSync(inspector_log)) {
    data = {
      articles: [],
      issues: {},
      pages: {},
      top10: {}
    };
    fs.writeFileSync(inspector_log, JSON.stringify(data), 'utf-8');
  }

  inspector_data = fs.readFileSync(inspector_log, 'utf-8');

  inspector_json_data = JSON.parse(inspector_data);

  mark_as_done = function(obj) {
    if (obj.object === 'article') {
      inspector_json_data.articles.push(obj.id);
      return fs.writeFileSync(inspector_log, JSON.stringify(inspector_json_data), 'utf-8');
    }
  };

  is_done = function(obj) {
    var ref;
    if (ref = obj.id, indexOf.call(inspector_json_data[obj.object], ref) >= 0) {
      return true;
    } else {
      return false;
    }
  };

  poolling = {
    mark_as_done: mark_as_done,
    is_done: is_done
  };

  module.exports = poolling;

}).call(this);