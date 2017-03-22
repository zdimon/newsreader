angular.module 'readerApp'
.config [ '$stateProvider', '$urlRouterProvider', ($stateProvider,$urlRouterProvider)->

    $urlRouterProvider.otherwise 'reader/index'

    $stateProvider
    .state 'menu',
        url: '/reader'
        templateUrl: 'templates/menu.html'
        controller: ()->
    .state 'menu.index',
        url: '/index'
        views:
            'content':
                templateUrl: 'templates/index.html'
                controller: 'indexCtrl'
    .state 'menu.journals',
        url: '/journals'
        views:
            'content':
                templateUrl: 'templates/journals.html'
                controller: 'journalsCtrl'
]
