angular.module 'readerApp'
.controller 'indexCtrl', [  '$scope', 'Top10', ($scope, Top10)->
        Top10.get_top10 (r)->
            $scope.top_list = r.articles
            console.log $scope.top_list

    ]
.controller 'journalsCtrl', [  '$scope', ($scope)->
        $scope.journals_list = [1,2,3,4]

    ]
