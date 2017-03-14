<<<<<<< HEAD
# News reader.

## Description.
=======
#News reader.

##Description.
>>>>>>> edc10f2c4a12533e63630a585975bce947cc13db

Server-client system of retrieving and representing a structured information from the pressa.ru service.

The information comes in follows JSON format:
<<<<<<< HEAD


    {
        "date": "2017-03-03",
        "articles": [
            {
=======
  

    {
        "date": "2017-03-03", 
        "articles": [
            { 
>>>>>>> edc10f2c4a12533e63630a585975bce947cc13db
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
<<<<<<< HEAD
=======


 
>>>>>>> edc10f2c4a12533e63630a585975bce947cc13db
