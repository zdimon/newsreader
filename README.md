# News reader.

## Requirements

    sudo apt-get install npm
    sudo apt-get install nodejs-legacy

## Deploy

    git clone git@github.com:zdimon/newsreader.git
    cd newsreader
    npm install
    npm run prod
    
> server will be started on 3000 port by default


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

    sudo apt-get install supervisor
    
### nano /etc/supervisor/conf.d/reader.conf

    [program:reader_server]
    command=/home/zdimon/newsreader/start.sh
    directory=/home/zdimon/newsreader
    user=zdimon
    autostart=true
    autorestart=true
    

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
