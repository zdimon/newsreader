# News reader.

## Requirements

    apt-get update
    sudo apt-get install nano git npm nodejs-legacy supervisor
    sudo npm install supervisor -g

## Deploy

    git clone git@github.com:zdimon/newsreader.git
    cd newsreader
    npm install
    npm run prod

> server will be started on 3000 port by default

## Project settings

Copy config file

    cp public/javascripts/_config.js public/javascripts/config.js

Edit URL to API server

    nano public/javascripts/config.js

set SERVER_URL

    var SERVER_URL = 'http://<your domain>'

## Proxy with nginx


    server {
        listen      80;
        client_max_body_size 100M;
        server_name <server-name>;

        location / {
               proxy_pass http://127.0.0.1:3000;
        }

Optionally you can proxy static files.


        location /javascripts {
            alias /home/zdimon/newsreader/public/javascripts/;
        }

        location /stylesheets {
            alias <path-to-project-dir>/public/stylesheets/;
        }

        location /templates {
            alias <path-to-project-dir>/public/templates/;
        }


       location /media {
            alias <path-to-project-dir>/public/media/;
        }

       location /fonts {
            alias <path-to-project-dir>/public/fonts/;
        }


## Run service in supervisor.

### nano /etc/supervisor/conf.d/reader.conf

    [program:reader_server]
    command=<path-to-project-dir>/start.sh
    directory=<path-to-project-dir>
    user=zdimon
    autostart=true
    autorestart=true


### Commands

**monitoring**

    supervisorctl

**restarting**

    service supervisor restart


## Description.


Server-client system of retrieving and representing a structured information from the pressa.ru service.

The information comes in follows JSON format:



    {
        "date": "2017-03-03",
        "articles": [
            {
                'id': ..,
                'title': ..,
                'short_text': ...,
                'text': ...,
                'text_continue': ...,
                'image': ...,
                'small_image': ...,
                'small_image_portrait': ...,
                'journal': ...,
                'issue': ...,
                'issue_id': ...,
                'reader_url': ...,
                'order': ...
            } ... {}
        ]
    }

It can be requested by follows URL:

    http://pressa.ru/mts/api/top10/2017-03-03.json

The information should be retrieved and saved on the server side.

It makes possible to work offline without internet connection.

As soon as the server get the internet connection it makes a request and retrievs new data from the pressa.ru service.
