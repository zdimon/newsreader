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

.controller 'magazinesCtrl', [  '$scope', '$stateParams', ($scope, $stateParams)->
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
      ]

    ]             


.controller 'readCtrl', [  '$scope', '$stateParams', ($scope, $stateParams)->
        $scope.journals_list = [1,2,3,4]
        
    ]


.controller 'catalogCtrl', [  '$scope', '$stateParams', '$state', '$rootScope', ($scope, $stateParams, $state, $rootScope)->
       
        $scope.go = (id)->
            $state.go 'reader.catalog_detail',
                id: id 

]


.controller 'catalogDetailCtrl', [  '$scope', '$stateParams', '$state', '$rootScope', 'Catalog', ($scope, $stateParams, $state, $rootScope, Catalog)->
        if $rootScope.catalog
            $scope.catalog = $rootScope.catalog.categories[$stateParams.id]
        else
            Catalog.get_catalog (rez)->
                $rootScope.catalog = rez
                $scope.catalog = $rootScope.catalog.categories[$stateParams.id]
        console.log $scope.catalog
        $scope.go = (id)->
            $state.go 'reader.journal_detail',
                catalog_id: $stateParams.id
                journal_id: id 

]


.controller 'journalDetailCtrl', [  '$scope', '$stateParams', '$state', '$rootScope', 'Catalog', ($scope, $stateParams, $state, $rootScope, Catalog)->
        if $rootScope.catalog
            $scope.journal = $rootScope.catalog.categories[$stateParams.catalog_id].journals[$stateParams.journal_id]
        else
            Catalog.get_catalog (rez)->
                $rootScope.catalog = rez
                $scope.journal = $rootScope.catalog.categories[$stateParams.catalog_id].journals[$stateParams.journal_id]
        
        $scope.go = (id)->
            console.log id
            $state.go 'reader.articles',
                journal_id: id 

]




.controller 'articlesCtrl', [  '$scope', '$stateParams', '$state', '$rootScope', 'Articles', ($scope, $stateParams, $state, $rootScope, Articles)->
        
        Articles.get_articles (rez)->
            $scope.articles = rez.articles
            console.log rez
        $scope.go = (article_id)->
            $state.go 'reader.article_detail',
                journal_id: $stateParams.journal_id
                article_id: article_id
]


.controller 'articleDetailCtrl', [  '$scope', '$stateParams', '$state', '$rootScope', 'Articles', ($scope, $stateParams, $state, $rootScope, Articles)->
    Articles.get_articles (rez)->
        $scope.articles = rez.articles
        angular.forEach $scope.articles, (v,k)->
            #console.log $stateParams.article_id
            if parseInt(v.id) == parseInt($stateParams.article_id)
                $scope.article = v    
                console.log v.id
        
             
]


