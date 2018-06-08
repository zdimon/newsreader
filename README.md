# News reader.

## Deploy (Ubuntu 16)


    apt-get update
    sudo apt-get install nano git npm nodejs-legacy supervisor nginx
    sudo npm install supervisor -g
    sudo npm install -g coffeescript


> If you want to clone repository via ssh you need to generate ssh key 'ssh-keygen' and then add to the github.com account.

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

## Proxy API server


    server {
        listen      80;
        client_max_body_size 100M;
        server_name <server-name>;

        location / {
               proxy_pass http://127.0.0.1:3000;
        }

##Proxy media directory with images.

        location /data {
        alias <path-to-project-dir>/data/;
    }   

##Proxy static files.

        location /dist {
            alias <path-to-project-dir>/public/dist/;
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


## Description API.


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
                'journal_name': ...,
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


## Installing on CentOS system.

yum install epel-release
yum upgrade
yum install nano git npm nodejs supervisor nginx 
npm install -g supervisor coffeescript jade easyimage
git clone https://github.com/zdimon/newsreader.git
cd newsreader
npm installakela40k, 6:23 PMenable supervisord service
systemctl enable supervisord
start supervisord service
systemctl start supervisord

make shure you have open 3000 port if you want standalone access
firewall-cmd --permanent --zone=public --add-port=3000/tcp







