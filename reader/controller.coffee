angular.module 'readerApp'
.controller 'indexCtrl', [  '$scope', 'Top10', '$state', '$rootScope', ($scope, Top10, $state, $rootScope)->
        Top10.get_top10 (r)->
            $rootScope.top_list = r
        $scope.go = (id)->
            $state.go 'reader.top_detail',
                id: id


    ]
.controller 'topDetailCtrl', [  '$scope', '$stateParams', '$rootScope', 'Top10', ($scope, $stateParams, $rootScope, Top10)->
        if $rootScope.top_list
            angular.forEach $rootScope.top_list.articles, (k,v)-> #search in
                if parseInt(k.id) == parseInt($stateParams.id)
                    $scope.article = k
        else
            Top10.get_top10 (r)->
                $rootScope.top_list = r
                angular.forEach $rootScope.top_list.articles, (k,v)-> #search in
                    if parseInt(k.id) == parseInt($stateParams.id)
                        $scope.article = k

]

.controller 'journalsCtrl', [  '$scope', '$stateParams', ($scope, $stateParams)->
        $scope.journals_list = [1,2,3,4,5,6]

        $scope.items = [
          {
            src:'/images/cover1.png',
            sub: 'This is a <b>subtitle</b>'
            thumb:'/images/high1.jpg'
          },
          {
            src:'/images/cover2.png',
            sub: ''
          },
          {
            src:'/images/cover1.png',
            thumb:'/images/high1.jpg'
          }
          {
            src:'/images/cover1.png',
            sub: 'This is a <b>subtitle</b>'
          },
          {
            src:'/images/cover2.png',
            sub: ''
          },
          {
            src:'/images/cover1.png',
            thumb:'/images/cover2.png'
          }
          {
            src:'/images/cover1.png',
            sub: 'This is a <b>subtitle</b>'
          },
          {
            src:'/images/cover2.png',
            sub: ''
          },
          {
            src:'/images/cover1.png',
            thumb:'/images/cover2.png'
          }
        ]

    ]


.controller 'readCtrl', [  '$scope', '$stateParams', ($scope, $stateParams)->
        $scope.journals_list = [1,2,3,4]

    ]
