SERVER_URL = "http://"+window.location.hostname+':'+window.location.port;

angular.module 'readerApp'
.factory 'Top10', [  '$http', ($http)->
        get_top10 = (callback)->
            $http(
                method: 'GET'
                url: "#{SERVER_URL}/top10"
            ).success(callback)

        return {
            get_top10
        }

]

.factory 'Catalog', [  '$http', ($http)->
        get_catalog = (callback)->
            $http(
                method: 'GET'
                url: "#{SERVER_URL}/catalog"
            ).success(callback)

        return {
            get_catalog
        }

]

.factory 'Articles', [  '$http', '$rootScope', ($http, $rootScope)->
        get_articles = (journal_id, issue_id, callback)->
            #if ($rootScope.articles)
            #    callback($rootScope.articles)
            #else
            $http(
                method: 'GET'
                url: "#{SERVER_URL}/articles/#{journal_id}/#{issue_id}.json"
            ).success(callback)

        return {
            get_articles
        }

]


.factory 'Issue', [  '$http', '$rootScope', ($http, $rootScope)->
        get_pages = (journal_id, issue_id, callback)->

            $http(
                method: 'GET'
                url: "#{SERVER_URL}/pages/#{journal_id}/#{issue_id}.json"
            ).success(callback)

        return {
            get_pages
        }

]

.factory 'Translator',  ()->

        messages = {
            'ТОП10': '前10名'
            "Газеты": "报纸"
            'Журналы': "期刊"
            'Женские': "女子"
            "Мужские": "男子"
            "Детские": "孩子"
            "Дом и семья": "家庭和家庭"
            "Спорт": "运动"
            "Общество и политика": "社会和政治"
            "Бизнес и финансы": "商业和金融"
            "Научно-популярные": "科普"
            "Досуг и развлечения": "休闲和娱乐"
        }

        translate = (key)->
            if getLang() == 'ch'
                return messages[key]
            else
                return key

        getLang = ()->
            matches = document.cookie.match(new RegExp(
                "(?:^|; )" + 'lang'.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
            ))

            if matches == null
                return undefined
            else
                return decodeURIComponent(matches[1])
            
           
        setLang = (name)->
            document.cookie = "lang="+name;

        defLang = ()->
            console.log(getLang('lang'))
            if getLang('lang') == undefined
                setLang('ru')
            else
                setLang(getLang('lang'))
            #alert( document.cookie )
        return { 
            translate,
            defLang,
            getLang,
            setLang
        }
