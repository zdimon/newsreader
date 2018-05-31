// Generated by CoffeeScript 1.9.3
(function() {
  var cleaner, creator, path, polling, problem, top10, top_polling;

  polling = require('async-polling');

  path = require('path');

  global.app_config = require('../config');

  global.app_root = path.resolve(__dirname, '../../..');

  top10 = require('./polling_top10');

  creator = require('./polling_creator');

  cleaner = require('./cleaner');

  problem = require('./polling_problem');

  top_polling = polling(top10.get_top10_from_server, 60000 * 30);

  top_polling.run();

  creator = polling(creator.periodic_handle, 60000 * 60);

  creator.run();

  cleaner = polling(cleaner.process_cleaning, 60000 * 60 * 24);

  cleaner.run();

  problem = polling(problem.process_problem, 60000 * 60 * 24);

  problem.run();

}).call(this);
