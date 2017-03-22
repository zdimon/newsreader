angular.module 'readerApp'
.controller 'indexCtrl', [  '$scope', ($scope)->
        $scope.top_list = [1,2,3, 4, 5] 

    ]
.controller 'journalsCtrl', [  '$scope', ($scope)->
        $scope.journals_list = [1,2,3,4]

    ]
