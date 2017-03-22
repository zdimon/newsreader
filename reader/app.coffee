angular.module('readerApp', ['ionic'])

.config ([ '$ionicConfigProvider', '$sceDelegateProvider', ($ionicConfigProvider, $sceDelegateProvider)->
    $sceDelegateProvider.resourceUrlWhitelist [ 'self','*://www.youtube.com/**', '*://player.vimeo.com/video/**']
])

.run ['$ionicPlatform', ($ionicPlatform)->
    $ionicPlatform.ready ()->
    # Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    # for form inputs)
        if window.cordova && window.cordova.plugins && window.cordova.plugins.Keyboard
            cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)
            cordova.plugins.Keyboard.disableScroll(true)

        if window.StatusBar
            #org.apache.cordova.statusbar required
            StatusBar.styleDefault()
]
