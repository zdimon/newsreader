#News reader.

##Description.

Server-client system of retriewing and representing a stuctured information from pressa.ru service.
Information comes in follows json format:

    {
        "date": "2017-03-03", 
        "articles": [
            { 
                'id': ..,
                'title': ..,
                'short_text': ...,
                'text': ...,
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

