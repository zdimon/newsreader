// Generated by CoffeeScript 1.9.3
(function() {
  var easyimg, fs, get_catalog, http, log, out, path, process_cleaning, request, requestSync, rimraf, utils,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  http = require('http');

  fs = require('fs');

  path = require('path');

  utils = require('../utils/utils');

  request = require('request');

  log = require('winston-color');

  log.level = process.env.LOG_LEVEL;

  easyimg = require('easyimage');

  requestSync = require('sync-request');

  rimraf = require('rimraf');

  get_catalog = function(id) {
    var catalog, dest, ik, iv, jk, jsondata, jv, k, ref, ref1, ref2, ref3, v;
    dest = path.join(global.app_root, global.app_config.data_dir, "catalog", "catalog.json");
    jsondata = JSON.parse(fs.readFileSync(dest, 'utf8'));
    catalog = {};
    console.log("Process ");
    ref = jsondata.categories;
    for (k in ref) {
      v = ref[k];
      ref1 = v.journals;
      for (jk in ref1) {
        jv = ref1[jk];
        if (!catalog[parseInt(jv.id)]) {
          catalog[parseInt(jv.id)] = [];
        }
        ref2 = jv.issues;
        for (ik in ref2) {
          iv = ref2[ik];
          if (ref3 = iv.id, indexOf.call(catalog[parseInt(jv.id)], ref3) < 0) {
            catalog[parseInt(jv.id)].push(iv.id);
          }
        }
      }
    }
    return catalog;
  };

  process_cleaning = function(clb) {
    var k, pt, ref, v;
    log.debug("CLEANER: starting...");
    ref = get_catalog();
    for (k in ref) {
      v = ref[k];
      pt = path.join(global.app_root, global.app_config.data_dir, "journals", k);
      if (fs.existsSync(pt)) {
        fs.readdirSync(pt).forEach(function(file) {
          var pathdel, ref1;
          if (ref1 = parseInt(file), indexOf.call(v, ref1) < 0) {
            pathdel = path.join(pt, file);
            rimraf(pathdel, function() {
              return log.debug("Removing " + pathdel);
            });
            pathdel = path.join(global.app_root, global.app_config.data_dir, "articles", k, file);
            return rimraf(pathdel, function() {
              return log.debug("Removing " + pathdel);
            });
          }
        });
      }
    }
    return clb();
  };

  out = {
    process_cleaning: process_cleaning
  };

  module.exports = out;

}).call(this);
