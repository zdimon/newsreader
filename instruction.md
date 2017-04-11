##Инструкции
Клонировать репозиторий
    
    git clone git@github.com:zdimon/newsreader.git
    
Запустить обновление.

    ./update.sh
    
Отредактировать конфигурационный файл /public/dist/config.js где прописать валидный URL сервера.

Проксировать папки nginx-ом.


    location /dist {
        alias /home/zdimon/newsreader/public/dist/;
    }

    location /data {
        alias /home/zdimon/newsreader/public/data/;
    }


        
