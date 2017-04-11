##Инструкции
1. Клонировать репозиторий
    
    git clone git@github.com:zdimon/newsreader.git
    
2. Запустить обновление.

    cd newsreader; sudo ./update.sh
    
3. Создать конфигурационный файл /public/dist/config.js где указать валидный URL сервера.

    echo "var SERVER_URL = 'http://localhost:3000'" > public/dist/js/config.js

Проксировать папки nginx-ом.


    location /dist {
        alias /home/zdimon/newsreader/public/dist/; 
    }

    location /data {
        alias /home/zdimon/newsreader/public/data/;
    }


4. Запустить сервер.

    ./start.sh        
        
