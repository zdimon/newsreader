// Generated by CoffeeScript 1.9.3
(function() {
  var articles_dir, catalog_dir, catalog_image_dir, data_dir, dest_pb, exec, fileName, fs, journal_dir, log, new_dir, path, queue_dir, top10_dir, top10_image_dir;

  exec = require('child_process').exec;

  fs = require('fs');

  path = require('path');

  log = require('winston-color');

  log.level = process.env.LOG_LEVEL;

  log.debug("Initialization....");

  fs.lstat(global.app_root + '/public/node_modules', function(err, stats) {
    var cmd;
    if (err) {
      cmd = "ln -s " + global.app_root + "/node_modules public/node_modules";
      return exec(cmd, function(err, stdout, stdin) {
        console.log(stdout);
        return console.log('Create simlink on node_modules.....');
      });
    }
  });

  data_dir = path.join(global.app_root, global.app_config.data_dir);

  top10_dir = path.join(data_dir, 'top10');

  catalog_dir = path.join(data_dir, 'catalog');

  top10_image_dir = path.join(data_dir, 'top10', 'images');

  journal_dir = path.join(global.app_root, global.app_config.data_dir, 'journals');

  catalog_image_dir = path.join(data_dir, 'catalog', 'images');

  articles_dir = path.join(data_dir, 'articles');

  new_dir = path.join(data_dir, 'new');

  queue_dir = path.join(data_dir, 'queue');

  if (!fs.existsSync(data_dir)) {
    log.info('Creating data dir......');
    fs.mkdirSync(data_dir);
  }

  if (!fs.existsSync(top10_dir)) {
    log.info('Creating top10_dir ......');
    fs.mkdirSync(top10_dir);
  }

  if (!fs.existsSync(top10_image_dir)) {
    log.info('Creating top10_image_dir ......');
    fs.mkdirSync(top10_image_dir);
  }

  if (!fs.existsSync(journal_dir)) {
    log.info('Creating journal_dir ......');
    fs.mkdirSync(journal_dir);
  }

  if (!fs.existsSync(catalog_dir)) {
    log.info('Creating catalog_dir ......');
    fs.mkdirSync(catalog_dir);
  }

  if (!fs.existsSync(catalog_image_dir)) {
    log.info('Creating catalog_image_dir ......');
    fs.mkdirSync(catalog_image_dir);
  }

  if (!fs.existsSync(articles_dir)) {
    log.info('Creating articles_dir ......');
    fs.mkdirSync(articles_dir);
  }

  if (!fs.existsSync(new_dir)) {
    log.info('Creating new_dir ......');
    fs.mkdirSync(new_dir);
  }

  if (!fs.existsSync(queue_dir)) {
    log.info('Creating queue ......');
    fs.mkdirSync(queue_dir);
  }

  dest_pb = path.join(global.app_root, global.app_config.data_dir, 'problem_journal.json');

  if (!fs.existsSync(dest_pb)) {
    log.info('Creating problem_journal.json ......');
    fs.writeFileSync(dest_pb, '[]');
  }

  dest_pb = path.join(global.app_root, global.app_config.data_dir, 'done.json');

  if (!fs.existsSync(dest_pb)) {
    log.info('Creating done.json ......');
    fs.writeFileSync(dest_pb, '[]');
  }

  fileName = 'tasks.json';

  fs.exists(fileName, function(exists) {
    var data;
    if (!exists) {
      console.log('Not exist!!');
      data = JSON.stringify([
        {
          "load_top_10": "loadTop10"
        }
      ]);
      console.log(data);
      return fs.writeFile(fileName, data, function(err) {
        if (err) {
          return console.log(err);
        }
      });
    }
  });

}).call(this);
