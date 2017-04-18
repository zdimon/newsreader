angular.module 'readerApp'
.config [ '$stateProvider', '$urlRouterProvider', ($stateProvider,$urlRouterProvider)->

    $urlRouterProvider.otherwise 'reader/index'

    $stateProvider
    .state 'reader',
        url: '/reader'
        templateUrl: 'dist/templates/menu.html'
        controller: ()->
    .state 'reader.index',
        url: '/index'
        views:
            'content':
                templateUrl: 'dist/templates/index.html'
                controller: 'indexCtrl'
    .state 'reader.top_detail',
        url: '/top/detail/:id'
        views:
            'content':
                templateUrl: 'dist/templates/top_detail.html'
                controller: 'topDetailCtrl'
    .state 'reader.read',
        url: '/read/:id'
        views:
            'content':
                templateUrl: 'dist/templates/read.html'
                controller: 'readCtrl'
    .state 'reader.journals',
        url: '/journals'
        views:
            'content':
                templateUrl: 'dist/templates/journals.html'
                controller: 'journalsCtrl'
    .state 'reader.magazines',
        url: '/magazines'
        views:
            'content':
                templateUrl: 'dist/templates/magazines.html'
                controller: 'magazinesCtrl'
    .state 'reader.catalog',
        url: '/catalog'
        views:
            'content':
                templateUrl: 'dist/templates/catalog.html'
                controller: 'catalogCtrl'
                
    .state 'reader.catalog_detail',
        url: '/catalog/detail/:id'
        views:
            'content':
                templateUrl: 'dist/templates/catalog_detail.html'
                controller: 'catalogDetailCtrl'
                
    .state 'reader.journal_detail',
        url: '/journal/detail/:catalog_id/:journal_id'
        views:
            'content':
                templateUrl: 'dist/templates/journal_detail.html'
                controller: 'journalDetailCtrl'
            
    .state 'reader.issue_detail',
        url: '/issue/detail/:journal_id/:issue_id'
        views:
            'content':
                templateUrl: 'dist/templates/issue_detail.html'
                controller: 'issueDetailCtrl'
                
    .state 'reader.page_detail',
        url: '/issue/detail/:journal_id/:issue_id/:page_id'
        views:
            'content':
                templateUrl: 'dist/templates/page_detail.html'
                controller: 'pageDetailCtrl'
                
                
    .state 'reader.articles',
        url: '/catalog/articles/:journal_id/:issue_id'
        views:
            'content':
                templateUrl: 'dist/templates/articles.html'
                controller: 'articlesCtrl'
                
    .state 'reader.article_detail',
        url: '/catalog/articles/detail/:journal_id/:issue_id/:article_id'
        views:
            'content':
                templateUrl: 'dist/templates/article_detail.html'
                controller: 'articleDetailCtrl'                  
                
]
