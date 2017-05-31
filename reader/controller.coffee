
init = ($rootScope)->
    $rootScope.show_forward = false
    $rootScope.show_backward = false

angular.module 'readerApp'
.controller 'indexCtrl', [  '$scope', 'Top10', '$state', '$rootScope', ($scope, Top10, $state, $rootScope)->
        init($rootScope)
        Top10.get_top10 (r)->
            $rootScope.top_list = r
        $scope.go = (id)->
            $state.go 'reader.top_detail',
                id: id


    ]
.controller 'topDetailCtrl', [  '$scope', '$stateParams', '$rootScope', 'Top10', ($scope, $stateParams, $rootScope, Top10)->
        init($rootScope)
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

.controller 'journalsCtrl', [  '$scope', '$stateParams', '$rootScope', ($scope, $stateParams, $rootScope)->
        init($rootScope)
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

.controller 'magazinesCtrl', [  '$scope', '$stateParams', '$rootScope', ($scope, $stateParams,$rootScope)->
        init($rootScope)
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


.controller 'readCtrl', [  '$scope', '$stateParams', '$rootScope', ($scope, $stateParams, $rootScope)->
        init($rootScope)
        $scope.journals_list = [1,2,3,4]
        
    ]


.controller 'catalogCtrl', [  '$scope', '$stateParams', '$state', '$rootScope', ($scope, $stateParams, $state, $rootScope)->
        init($rootScope)
       
        $scope.go = (id)->
            $state.go 'reader.catalog_detail',
                id: id 

]


.controller 'catalogDetailCtrl', [  '$scope', '$stateParams', '$state', '$rootScope', 'Catalog', ($scope, $stateParams, $state, $rootScope, Catalog)->
        init($rootScope)
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
        init($rootScope)
        if $rootScope.catalog
            $scope.journal = $rootScope.catalog.categories[$stateParams.catalog_id].journals[$stateParams.journal_id]
        else
            Catalog.get_catalog (rez)->
                $rootScope.catalog = rez
                $scope.journal = $rootScope.catalog.categories[$stateParams.catalog_id].journals[$stateParams.journal_id]
        
        $scope.go = (id,txt)->
            
            if txt
                $state.go 'reader.articles',
                    issue_id: id
                    journal_id: $stateParams.journal_id
            else
                console.log txt
                $state.go 'reader.issue_detail',
                    issue_id: id
                    journal_id: $stateParams.journal_id              

]


.controller 'issueDetailCtrl', [  '$scope', '$stateParams', '$state', '$rootScope', 'Issue', ($scope, $stateParams, $state, $rootScope, Issue)->
        init($rootScope)
        Issue.get_pages $stateParams.journal_id, $stateParams.issue_id, (rez)->
            $scope.issue = rez
            $scope.pages = rez.pages
        
        $scope.go = (page_id)->
            $state.go 'reader.page_detail',
                journal_id: $stateParams.journal_id
                issue_id: $stateParams.issue_id
                page_id: page_id
]



.controller 'pageDetailCtrl', [  '$scope', '$stateParams', '$state', '$rootScope', 'Issue', ($scope, $stateParams, $state, $rootScope, Issue)->
        init($rootScope)
        
        Issue.get_pages $stateParams.journal_id, $stateParams.issue_id, (rez)->
            console.log 'Pages'
            $scope.issue = rez
            $scope.pages = rez.pages
            $scope.page = rez.pages.pages[$stateParams.page_id]
            console.log $scope.page
            $rootScope.show_forward = true
            $rootScope.show_backward = true
            $rootScope.go_forward = ()->
                $state.go 'reader.page_detail',
                  journal_id: $stateParams.journal_id
                  issue_id: $stateParams.issue_id
                  page_id: parseInt($stateParams.page_id)+1
            $rootScope.go_backward = ()->
                $state.go 'reader.page_detail',
                  journal_id: $stateParams.journal_id
                  issue_id: $stateParams.issue_id
                  page_id: parseInt($stateParams.page_id)-1 
                  
]


.controller 'articlesCtrl', [  '$scope', '$stateParams', '$state', '$rootScope', 'Articles', ($scope, $stateParams, $state, $rootScope, Articles)->
        init($rootScope)
        
        Articles.get_articles $stateParams.journal_id, $stateParams.issue_id, (rez)->
            $scope.articles = rez.articles
            
        $scope.go = (article_id)->
            $state.go 'reader.article_detail',
                journal_id: $stateParams.journal_id
                issue_id: $stateParams.issue_id
                article_id: article_id
]


.controller 'articleDetailCtrl', [  '$scope', '$stateParams', '$state', '$rootScope', 'Articles', ($scope, $stateParams, $state, $rootScope, Articles)->
    init($rootScope)
    Articles.get_articles $stateParams.journal_id, $stateParams.issue_id, (rez)->
        $scope.articles = rez.articles
        $scope.swipLeft = ()->
            alert 'left'
        $scope.swipRight = ()->
            console.log 'right'
        angular.forEach $scope.articles, (v,k)->
            #console.log $stateParams.article_id
            if parseInt(v.id) == parseInt($stateParams.article_id)
                $scope.article = v    
                console.log v.id 
        
             
]


