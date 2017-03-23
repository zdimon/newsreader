// Generated by CoffeeScript 1.11.1
(function() {
  angular.module('readerApp').controller('indexCtrl', [
    '$scope', 'Top10', '$state', '$rootScope', function($scope, Top10, $state, $rootScope) {
      Top10.get_top10(function(r) {
        return $rootScope.top_list = r.articles;
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
        return angular.forEach($rootScope.top_list, function(k, v) {
          if (parseInt(k.id) === parseInt($stateParams.id)) {
            return $scope.article = k;
          }
        });
      } else {
        return Top10.get_top10(function(r) {
          $rootScope.top_list = r.articles;
          return angular.forEach($rootScope.top_list, function(k, v) {
            if (parseInt(k.id) === parseInt($stateParams.id)) {
              return $scope.article = k;
            }
          });
        });
      }
    }
  ]).controller('readCtrl', [
    '$scope', '$stateParams', function($scope, $stateParams) {
      return $scope.journals_list = [1, 2, 3, 4];
    }
  ]);

}).call(this);
