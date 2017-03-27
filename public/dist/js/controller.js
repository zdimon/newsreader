// Generated by CoffeeScript 1.11.1
(function() {
  angular.module('readerApp').controller('indexCtrl', [
    '$scope', 'Top10', '$state', '$rootScope', function($scope, Top10, $state, $rootScope) {
      Top10.get_top10(function(r) {
        return $rootScope.top_list = r;
      });
      return $scope.go = function(id) {
        return $state.go('reader.top_detail', {
          id: id
        });
      };
    }
  ]).controller('topDetailCtrl', [
    '$scope', '$stateParams', '$rootScope', 'Top10', function($scope, $stateParams, $rootScope, Top10) {
      if ($rootScope.top_list) {
        return angular.forEach($rootScope.top_list.articles, function(k, v) {
          if (parseInt(k.id) === parseInt($stateParams.id)) {
            return $scope.article = k;
          }
        });
      } else {
        return Top10.get_top10(function(r) {
          $rootScope.top_list = r;
          return angular.forEach($rootScope.top_list.articles, function(k, v) {
            if (parseInt(k.id) === parseInt($stateParams.id)) {
              return $scope.article = k;
            }
          });
        });
      }
    }
  ]).controller('journalsCtrl', [
    '$scope', '$stateParams', function($scope, $stateParams) {
      $scope.journals_list = [1, 2, 3, 4, 5, 6];
      return $scope.items = [
        {
          src: '/images/cover1.png',
          sub: 'This is a <b>subtitle</b>',
          thumb: '/images/high1.jpg'
        }, {
          src: '/images/cover2.png',
          sub: ''
        }, {
          src: '/images/cover1.png',
          thumb: '/images/high1.jpg'
        }, {
          src: '/images/cover1.png',
          sub: 'This is a <b>subtitle</b>'
        }, {
          src: '/images/cover2.png',
          sub: ''
        }, {
          src: '/images/cover1.png',
          thumb: '/images/cover2.png'
        }, {
          src: '/images/cover1.png',
          sub: 'This is a <b>subtitle</b>'
        }, {
          src: '/images/cover2.png',
          sub: ''
        }, {
          src: '/images/cover1.png',
          thumb: '/images/cover2.png'
        }
      ];
    }
  ]).controller('magazinesCtrl', [
    '$scope', '$stateParams', function($scope, $stateParams) {
      return $scope.items = [
        {
          src: '/images/cover1.png',
          sub: 'This is a <b>subtitle</b>',
          thumb: '/images/high1.jpg'
        }, {
          src: '/images/cover2.png',
          sub: ''
        }, {
          src: '/images/cover1.png',
          thumb: '/images/high1.jpg'
        }
      ];
    }
  ]).controller('readCtrl', [
    '$scope', '$stateParams', function($scope, $stateParams) {
      return $scope.journals_list = [1, 2, 3, 4];
    }
  ]);

}).call(this);
