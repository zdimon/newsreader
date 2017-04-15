#!/bin/bash
if [ -z "$1" ]
    then
        echo "No argument supplied"
        supervisor -i node_modules,public/node_modules,data -e "node|js|coffee" ./bin/www
    else
        echo $1
        LOG_LEVEL=$1 supervisor -i node_modules,public/node_modules,data ./bin/www 
fi

