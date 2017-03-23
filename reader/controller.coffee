angular.module 'readerApp'
.controller 'indexCtrl', [  '$scope', 'Top10', '$state', '$rootScope', ($scope, Top10, $state, $rootScope)->
        Top10.get_top10 (r)->
            $rootScope.top_list = r.articles
        $scope.go = (id)->
            $state.go 'reader.top_detail',
                id: id


    ]
.controller 'topDetailCtrl', [  '$scope', '$stateParams', '$rootScope', ($scope, $stateParams, $rootScope)->
        angular.forEach $rootScope.top_list, (k,v)->
            if parseInt(k.id) == parseInt($stateParams.id)
                $scope.article = k

]

.controller 'readCtrl', [  '$scope', '$stateParams', ($scope, $stateParams)->
        $scope.journals_list = [1,2,3,4]

    ]
