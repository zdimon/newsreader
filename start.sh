#!/bin/bash
kill $(lsof -t -i:3000)
nodemon ./bin/www
