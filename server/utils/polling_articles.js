// Generated by CoffeeScript 1.12.4
(function() {
  var fs, get_articles_from_server, http, log, path, poolling, request, utils;

  http = require('http');

  fs = require('fs');

  path = require('path');

  utils = require('../utils/utils');

  request = require('request');

  log = require('winston-color');

  log.level = process.env.LOG_LEVEL;

  log.debug("Importing polling articles module");

  get_articles_from_server = function() {
    return log.debug("ARTICLES: Start request from ..");
  };

  poolling = {
    get_articles_from_server: get_articles_from_server
  };

  module.exports = poolling;

}).call(this); 
