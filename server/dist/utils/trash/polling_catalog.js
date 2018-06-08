// Generated by CoffeeScript 1.9.3
(function() {
  var article, download_images, download_issues, fs, get_catalog_from_server, http, issue, log, pages, path, poolling, process_cover, process_issue, request, requestSync, utils;

  http = require('http');

  fs = require('fs');

  path = require('path');

  utils = require('../utils/utils');

  request = require('request');

  issue = require('./polling_issues');

  log = require('winston-color');

  log.level = process.env.LOG_LEVEL;

  log.debug("Importing polling catalog module");

  article = require('./polling_articles');

  pages = require('./polling_pages');

  requestSync = require('sync-request');

  download_images = function(data) {
    var image_dir, image_path, jk, jv, k, ref, res, results, v;
    log.debug('CALALOG: Downloading images');
    ref = data.categories;
    results = [];
    for (k in ref) {
      v = ref[k];
      results.push((function() {
        var ref1, results1;
        ref1 = v.journals;
        results1 = [];
        for (jk in ref1) {
          jv = ref1[jk];
          image_dir = path.join(global.app_root, global.app_config.data_dir, 'catalog', 'images', "" + jv.id);
          if (!fs.existsSync(image_dir)) {
            log.info("Creating image_dir for " + jv.id);
            fs.mkdirSync(image_dir);
          }
          image_path = path.join(image_dir, "cover.png");
          if (!fs.existsSync(image_path)) {
            res = requestSync('GET', jv.thumb);
            fs.writeFileSync(image_path, res.getBody());
            results1.push(log.debug("CATALOG: Image saved " + jv.id));
          } else {
            results1.push(void 0);
          }
        }
        return results1;
      })());
    }
    return results;
  };

  download_issues = function(jsondata) {
    var ik, iv, jk, jv, k, ref, results, v;
    ref = jsondata.categories;
    results = [];
    for (k in ref) {
      v = ref[k];
      results.push((function() {
        var ref1, results1;
        ref1 = v.journals;
        results1 = [];
        for (jk in ref1) {
          jv = ref1[jk];
          results1.push((function() {
            var ref2, results2;
            ref2 = jv.issues;
            results2 = [];
            for (ik in ref2) {
              iv = ref2[ik];
              results2.push(process_issue(iv));
            }
            return results2;
          })());
        }
        return results1;
      })());
    }
    return results;
  };

  process_cover = function(jsdata) {
    var image_path, res;
    image_path = path.join(global.app_root, global.app_config.data_dir, 'journals', jsdata.journal_id + "/" + jsdata.id + "/cover.png");
    if (!fs.existsSync(image_path)) {
      log.debug("CATALOG: save cover " + image_path);
      res = requestSync('GET', jsdata.thumb);
      try {
        return fs.writeFileSync(image_path, res.getBody());
      } catch (_error) {
        return log.error("Error writing " + image_path);
      }
    }
  };

  process_issue = function(jsdata) {
    var cont, dest, dest_pages, issue_covers_dir, issue_dir, issue_page_dir, journal_dir;
    journal_dir = path.join(global.app_root, global.app_config.data_dir, 'journals', "" + jsdata.journal_id);
    if (!fs.existsSync(journal_dir)) {
      log.verbose("Creating " + journal_dir);
      fs.mkdirSync(journal_dir);
    }
    issue_dir = path.join(journal_dir, "" + jsdata.id);
    if (!fs.existsSync(issue_dir)) {
      log.verbose("Creating " + issue_dir);
      fs.mkdirSync(issue_dir);
    }
    issue_page_dir = path.join(issue_dir, "pages");
    if (!fs.existsSync(issue_page_dir)) {
      log.verbose("Creating " + issue_page_dir);
      fs.mkdirSync(issue_page_dir);
    }
    issue_covers_dir = path.join(issue_dir, "thumbnails");
    if (!fs.existsSync(issue_covers_dir)) {
      log.verbose("Creating " + issue_covers_dir);
      fs.mkdirSync(issue_covers_dir);
    }
    dest = path.join(issue_dir, "info.json");
    cont = fs.writeFileSync(dest, JSON.stringify(jsdata));
    log.verbose("CATALOG: creating info.json for " + jsdata.journal_id + "-" + jsdata.id);
    pages.process_issue(jsdata);
    process_cover(jsdata);
    dest_pages = path.join(issue_dir, "pages.json");
    if (!fs.existsSync(dest_pages)) {
      log.debug("NO PAGES! " + dest_pages);
      return pages.save_page_json(jsdata);
    }
  };

  get_catalog_from_server = function(end) {
    var dest, jsdata, out, res, url;
    article.grab_articles();
    url = 'http://pressa.ru/zd/catalog.json';
    log.debug("CATALOG: Start request from " + url);
    dest = path.join(global.app_root, global.app_config.data_dir, "catalog", "catalog.json");
    res = requestSync('GET', url);
    if (res.statusCode === 200) {
      out = res.getBody('utf8');
      jsdata = JSON.parse(out);
      fs.writeFileSync(dest, out);
      article.grab_articles();
      download_issues(jsdata);
      log.debug("CATALOG: finished");
    } else {
      log.error("Error geting calalog from " + url);
    }
    return end();

    /*
    req = http.get(url,(res)->
        out = ''
        res.on 'data', (chunk)-> #collect data
            out = out + chunk
        res.on 'end', ()->
            jsdata = JSON.parse(out)
            
            fs.writeFile dest, out, (err)-> # write to disk
                if err
                    log.error(err)
                console.log "The file #{dest} has been saved!"
                download_images(jsdata)
                download_issues(jsdata)
                article.get_articles_from_server()
            #log.debug out
        )
         
    req.on 'socket', (socket)-> 
        socket.setTimeout 15000
        socket.on 'timeout', ()->
            req.abort()
    req.on 'error', (err)->
        if err.code == 'ECONNRESET'
            log.error 'Timeout occurs!!'
     */
  };

  poolling = {
    get_catalog_from_server: get_catalog_from_server,
    process_issue: process_issue,
    process_cover: process_cover
  };

  module.exports = poolling;

}).call(this);