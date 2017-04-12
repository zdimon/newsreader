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