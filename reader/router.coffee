angular.module 'readerApp'
.config [ '$stateProvider', '$urlRouterProvider', ($stateProvider,$urlRouterProvider)->

    $urlRouterProvider.otherwise '/'

    index =
        name: 'index'
        url: '/'
        controller: 'topCtrl'
        templateUrl: 'templates/index.html'

    $stateProvider.state(index)
]
