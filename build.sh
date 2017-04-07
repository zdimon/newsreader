#!/bin/bash
echo 'Building SERVER.......'
coffee -c -o server/dist server/src
echo 'Building READER.......'
coffee -c -o public/dist/js reader
echo 'Building Templates.......'
jade -o public/dist/templates reader