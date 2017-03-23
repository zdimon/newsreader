angular.module 'readerApp'
.controller 'indexCtrl', [  '$scope', 'Top10', '$state', '$rootScope', ($scope, Top10, $state, $rootScope)->
        Top10.get_top10 (r)->
            $rootScope.top_list = r.articles
        $scope.go = (id)->
            $state.go 'reader.top_detail',
                id: id


    ]
.controller 'topDetailCtrl', [  '$scope', '$stateParams', '$rootScope', 'Top10', ($scope, $stateParams, $rootScope, Top10)->
        if $rootScope.top_list
            angular.forEach $rootScope.top_list, (k,v)-> #search in
                if parseInt(k.id) == parseInt($stateParams.id)
                    $scope.article = k
        else
            Top10.get_top10 (r)->
                $rootScope.top_list = r.articles
                angular.forEach $rootScope.top_list, (k,v)-> #search in
                    if parseInt(k.id) == parseInt($stateParams.id)
                        $scope.article = k                          

]

.controller 'readCtrl', [  '$scope', '$stateParams', ($scope, $stateParams)->
        $scope.journals_list = [1,2,3,4]

    ]
