# News reader.

## Requirements

    sudo apt-get install npm
    sudo apt-get install nodejs-legacy

## Deploy

    git clone git@github.com:zdimon/newsreader.git
    cd newsreader
    npm install
    npm start


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
