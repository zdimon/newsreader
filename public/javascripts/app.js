// Generated by CoffeeScript 1.11.1
(function() {
  angular.module('readerApp', ['ionic']).config([
    '$ionicConfigProvider', '$sceDelegateProvider', function($ionicConfigProvider, $sceDelegateProvider) {
      return $sceDelegateProvider.resourceUrlWhitelist(['self', '*://www.youtube.com/**', '*://player.vimeo.com/video/**']);
    }
  ]).run([
    '$ionicPlatform', function($ionicPlatform) {
      return $ionicPlatform.ready(function() {
        if (window.cordova && window.cordova.plugins && window.cordova.plugins.Keyboard) {
          cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
          cordova.plugins.Keyboard.disableScroll(true);
        }
        if (window.StatusBar) {
          return StatusBar.styleDefault();
        }
      });
    }
  ]);

}).call(this);
