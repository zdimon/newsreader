angular.module 'readerApp'
.config [ '$stateProvider', '$urlRouterProvider', ($stateProvider,$urlRouterProvider)->

    $urlRouterProvider.otherwise 'reader/index'

    $stateProvider
    .state 'reader',
        url: '/reader'
        templateUrl: 'templates/menu.html'
        controller: ()->
    .state 'reader.index',
        url: '/index'
        views:
            'content':
                templateUrl: 'templates/index.html'
                controller: 'indexCtrl'
    .state 'reader.top_detail',
        url: '/top/detail/:id'
        views:
            'content':
                templateUrl: 'templates/top_detail.html'
                controller: 'topDetailCtrl'
    .state 'reader.read',
        url: '/read/:id'
        views:
            'content':
                templateUrl: 'templates/read.html'
                controller: 'readCtrl'
    .state 'reader.journals',
        url: '/journals'
        views:
            'content':
                templateUrl: 'templates/journals.html'
                controller: 'journalsCtrl'
]
