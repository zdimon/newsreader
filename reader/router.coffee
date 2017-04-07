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
]
