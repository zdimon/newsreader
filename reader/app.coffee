angular.module('readerApp', ['ionic', 'ion-gallery'])

.config ([ '$ionicConfigProvider', '$sceDelegateProvider', 'ionGalleryConfigProvider', ($ionicConfigProvider, $sceDelegateProvider, ionGalleryConfigProvider)->
    $sceDelegateProvider.resourceUrlWhitelist [ 'self','*://www.youtube.com/**', '*://player.vimeo.com/video/**']

    ionGalleryConfigProvider.setGalleryConfig({
                          action_label: 'Close',
                          toggle: false,
                          row_size: 2,
                          fixed_row_size: false
                          });

])

.run ['$ionicPlatform', '$rootScope', 'Catalog', '$ionicHistory', 'Translator', ($ionicPlatform, $rootScope, Catalog, $ionicHistory, Translator)->
    $ionicPlatform.ready ()->

        # set locale
        #if 
        Translator.defLang()
        $rootScope.lang = Translator.getLang()

        


        Catalog.get_catalog (rez)->
              $rootScope.$broadcast('get-catalog',rez);        
              $rootScope.catalog = rez
              #console.log rez
    # Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    # for form inputs)
        if window.cordova && window.cordova.plugins && window.cordova.plugins.Keyboard
            cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)
            cordova.plugins.Keyboard.disableScroll(true)

        if window.StatusBar
            #org.apache.cordova.statusbar required
            StatusBar.styleDefault()

        $rootScope.trans = (key)->
            Translator.translate(key)
        
        $rootScope.change_lang = (lang)->
            Translator.setLang(lang)
            $rootScope.lang = Translator.getLang()
            
        $rootScope.$ionicGoBack = (backCount)->
            $ionicHistory.goBack(backCount)
            $rootScope.show_forward = false
            $rootScope.show_backward = false
            
            
]
