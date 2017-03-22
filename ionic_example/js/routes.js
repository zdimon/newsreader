angular.module('app.routes', [])

.config(function($stateProvider, $urlRouterProvider) {

  // Ionic uses AngularUI Router which uses the concept of states
  // Learn more here: https://github.com/angular-ui/ui-router
  // Set up the various states which the app can be in.
  // Each state's controller can be found in controllers.js
  $stateProvider
    
  

      .state('menu.page1', {
    url: '/page1',
    views: {
      'side-menu21': {
        templateUrl: 'templates/page1.html',
        controller: 'page1Ctrl'
      }
    }
  })

  .state('menu.page2', {
    url: '/page2',
    views: {
      'side-menu21': {
        templateUrl: 'templates/page2.html',
        controller: 'page2Ctrl'
      }
    }
  })

  .state('menu.page3', {
    url: '/page3',
    views: {
      'side-menu21': {
        templateUrl: 'templates/page3.html',
        controller: 'page3Ctrl'
      }
    }
  })

  .state('menu', {
    url: '/side-menu21',
    templateUrl: 'templates/menu.html',
    controller: 'menuCtrl'
  })

  .state('menu.page4', {
    url: '/page4',
    views: {
      'side-menu21': {
        templateUrl: 'templates/page4.html',
        controller: 'page4Ctrl'
      }
    }
  })

  .state('menu.page5', {
    url: '/page5',
    views: {
      'side-menu21': {
        templateUrl: 'templates/page5.html',
        controller: 'page5Ctrl'
      }
    }
  })

  .state('menu.page6', {
    url: '/page6',
    views: {
      'side-menu21': {
        templateUrl: 'templates/page6.html',
        controller: 'page6Ctrl'
      }
    }
  })

  .state('menu.page7', {
    url: '/page7',
    views: {
      'side-menu21': {
        templateUrl: 'templates/page7.html',
        controller: 'page7Ctrl'
      }
    }
  })

  .state('page8', {
    url: '/page8',
    templateUrl: 'templates/page8.html',
    controller: 'page8Ctrl'
  })

  .state('menu.image', {
    url: '/page9',
    views: {
      'side-menu21': {
        templateUrl: 'templates/image.html',
        controller: 'imageCtrl'
      }
    }
  })

  .state('menu.video', {
    url: '/page10',
    views: {
      'side-menu21': {
        templateUrl: 'templates/video.html',
        controller: 'videoCtrl'
      }
    }
  })

  .state('menu.html', {
    url: '/page11',
    views: {
      'side-menu21': {
        templateUrl: 'templates/html.html',
        controller: 'htmlCtrl'
      }
    }
  })

  .state('menu.lists', {
    url: '/page12',
    views: {
      'side-menu21': {
        templateUrl: 'templates/lists.html',
        controller: 'listsCtrl'
      }
    }
  })

  .state('menu.elements', {
    url: '/page13',
    views: {
      'side-menu21': {
        templateUrl: 'templates/elements.html',
        controller: 'elementsCtrl'
      }
    }
  })

$urlRouterProvider.otherwise('/side-menu21/page1')

  

});