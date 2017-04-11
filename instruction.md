##Инструкции
Клонировать репозиторий
    
    git clone git@github.com:zdimon/newsreader.git
    
Запустить обновление.

    ./update.sh
    
Отредактировать конфигурационный файл /public/dist/config.js где прописать валидный URL сервера.

    echo "var SERVER_URL = 'http://localhost:3000'" > public/dist/js/config.js

Проксировать папки nginx-ом.


    location /dist {
        alias /home/zdimon/newsreader/public/dist/; 
    }

    location /data {
        alias /home/zdimon/newsreader/public/data/;
    }


        
