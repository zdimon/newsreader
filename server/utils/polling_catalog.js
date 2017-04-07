// Generated by CoffeeScript 1.12.4
(function() {
  var fs, get_catalog_from_server, http, log, path, poolling, request, utils;

  http = require('http');

  fs = require('fs');

  path = require('path');

  utils = require('../utils/utils');

  request = require('request');

  log = require('winston-color');

  log.level = process.env.LOG_LEVEL;

  log.debug("Importing polling catalog");

  get_catalog_from_server = function() {
    return log.debug("CATALOG: Start request from ..");
  };

  poolling = {
    get_catalog_from_server: get_catalog_from_server
  };

  module.exports = poolling;

}).call(this);
