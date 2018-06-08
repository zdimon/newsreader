// Generated by CoffeeScript 1.9.3
(function() {
  var done_path, donedata, fs, getCatalog, getCover, getNew, getPages, getPagesJSON, handle, http, log, parseCatalog, path, periodic_handle, poolling, queue, request, requestSync, setArticles, utils,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  http = require('http');

  fs = require('fs');

  path = require('path');

  utils = require('../utils/utils');

  request = require('request');

  log = require('winston-color');

  log.level = process.env.LOG_LEVEL;

  log.debug("Importing polling creator module");

  requestSync = require('sync-request');

  queue = require('./polling_queue');


  /*
      Function makes a request to server and pass json
      data to the callback function
   */

  done_path = path.join(global.app_root, global.app_config.data_dir, 'done.json');

  log.debug("Checking " + done_path);

  if (!fs.existsSync(done_path)) {
    fs.writeFileSync(done_path, "[]");
  }

  donedata = fs.readFileSync(done_path, 'utf-8');

  donedata = JSON.parse(donedata);

  setArticles = function(jsdata, isssue_out) {

    /*
    article_dir = path.join(global.app_root, global.app_config.data_dir, 'articles', "#{jsdata.journal_id}")
    if !fs.existsSync article_dir
        log.verbose "Creating #{article_dir}"
        fs.mkdirSync article_dir
    article_dir = path.join(article_dir, "#{jsdata.id}")
    if !fs.existsSync article_dir
        log.verbose "Creating #{article_dir}"
        fs.mkdirSync article_dir
     */
    var dest, k, out, pt, ref, res, url, v;
    url = "http://pressa.ru/zd/txt/" + jsdata.id + ".json";
    dest = path.join(global.app_root, global.app_config.data_dir, "articles", jsdata.journal_id + "/" + jsdata.id + "/articles.json");
    isssue_out.push({
      path: dest,
      uri: url,
      type: 'article-json'
    });
    res = requestSync('GET', url);
    out = JSON.parse(res.getBody('utf8'));
    ref = out.articles;
    for (k in ref) {
      v = ref[k];
      pt = path.join(global.app_root, global.app_config.data_dir, "articles", jsdata.journal_id + "/" + jsdata.id + "/" + v.id + ".jpg");
      isssue_out.push({
        type: 'article-image',
        path: pt,
        uri: v.square_image
      });
      pt = path.join(global.app_root, global.app_config.data_dir, "articles", jsdata.journal_id + "/" + jsdata.id + "/" + v.id + "_big.jpg");
      isssue_out.push({
        type: 'article-image',
        path: pt,
        uri: v.image
      });
    }
    return isssue_out;
  };

  getCatalog = function() {
    var dest, jsdata, out, res, url;
    log.debug('Start process');
    url = 'http://pressa.ru/zd/catalog.json';
    log.debug("QUEUE CREATOR: get catalog from " + url);
    dest = path.join(global.app_root, global.app_config.data_dir, "catalog", "catalog.json");
    res = requestSync('GET', url);
    if (res.statusCode === 200) {
      out = res.getBody('utf8');
      jsdata = JSON.parse(out);
      fs.writeFileSync(dest, out);
      return jsdata;
    } else {
      return [];
    }
  };

  getCover = function(jsdata) {
    var image_path;
    image_path = path.join(global.app_root, global.app_config.data_dir, 'journals', jsdata.journal_id + "/" + jsdata.id + "/cover.png");
    return {
      path: image_path,
      uri: jsdata.thumb,
      type: 'cover'
    };
  };

  getPagesJSON = function(jsdata, url) {
    var dest_pages;
    dest_pages = path.join(global.app_root, global.app_config.data_dir, 'journals', jsdata.journal_id + "/" + jsdata.id, "pages.json");
    return {
      path: dest_pages,
      uri: url,
      type: 'pages-json'
    };
  };

  getPages = function(url, isssue_out, jsdata) {
    var im_url, jsdatapages, k, pathp, ref, res, v;
    res = requestSync('GET', url);
    jsdatapages = JSON.parse(res.getBody());
    ref = jsdatapages.pages;
    for (k in ref) {
      v = ref[k];
      pathp = path.join(global.app_root, global.app_config.data_dir, 'journals', jsdata.journal_id + "/" + jsdata.id, "thumbnails", v.number + ".jpeg");
      isssue_out.push({
        path: pathp,
        uri: "http://pressa.ru" + v.cover,
        type: 'page-thumb'
      });
      im_url = "http://" + global.remote_host + "/zd/page/" + v.id + "/secretkey.json";
      pathp = path.join(global.app_root, global.app_config.data_dir, 'journals', jsdata.journal_id + "/" + jsdata.id, "pages", v.number + ".jpeg");
      isssue_out.push({
        path: pathp,
        uri: im_url,
        type: 'page'
      });
    }
    return isssue_out;
  };

  parseCatalog = function(jsondata) {
    var dest, ik, isssue_out, iv, jk, jv, k, ref, results, url, v;
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
            var ref2, ref3, results2;
            ref2 = jv.issues;
            results2 = [];
            for (ik in ref2) {
              iv = ref2[ik];
              if (ref3 = iv.id, indexOf.call(donedata, ref3) < 0) {
                isssue_out = [];
                dest = path.join(global.app_root, global.app_config.data_dir, "queue", iv.journal_id + "-" + iv.id + ".json");
                if (!fs.existsSync(dest)) {
                  if (iv.has_articles) {
                    isssue_out = setArticles(iv, isssue_out);
                  }
                  url = "http://" + global.remote_host + "/zd/" + iv.id + ".json";
                  isssue_out.push(getCover(iv));
                  isssue_out.push(getPagesJSON(iv, url));
                  isssue_out = getPages(url, isssue_out, iv);
                  isssue_out.push({
                    type: 'info',
                    content: iv
                  });
                  log.debug("QUEUE CREATOR: " + iv.journal_id + "-" + iv.id + ".json");
                  results2.push(fs.writeFileSync(dest, JSON.stringify(isssue_out)));
                } else {
                  results2.push(void 0);
                }
              } else {
                results2.push(void 0);
              }
            }
            return results2;
          })());
        }
        return results1;
      })());
    }
    return results;
  };

  getNew = function() {
    var data, date, dest, dt, month, res, url, year;
    dt = new Date();
    month = ('0' + (dt.getMonth() + 1)).slice(-2);
    date = ('0' + dt.getDate()).slice(-2);
    year = dt.getFullYear();
    data = year + "-" + month + "-" + date;
    url = "http://" + global.remote_host + "/static/api/zd/" + data + "n.json";
    dest = path.join(global.app_root, global.app_config.data_dir, "new", data + ".json");
    res = requestSync('GET', url);
    return fs.writeFileSync(dest, res.getBody('utf8'));
  };

  handle = function(callback) {
    var data;
    getNew();
    data = getCatalog();
    parseCatalog(data);
    return callback();
  };

  periodic_handle = function(end) {
    return handle(function() {
      log.debug('Creator has finished a job!');
      return queue.handle(function() {
        log.debug('Queue has finished a job!');
        return end();
      });
    });
  };

  poolling = {
    handle: handle,
    periodic_handle: periodic_handle,
    getNew: getNew
  };

  module.exports = poolling;

}).call(this);