#!/bin/bash
git checkout prod
git pull
npm install
npm install -g coffeescript
npm run build
