// Generated by CoffeeScript 1.12.4
(function() {
  angular.module('readerApp', ['ionic', 'ion-gallery']).config([
    '$ionicConfigProvider', '$sceDelegateProvider', 'ionGalleryConfigProvider', function($ionicConfigProvider, $sceDelegateProvider, ionGalleryConfigProvider) {
      $sceDelegateProvider.resourceUrlWhitelist(['self', '*://www.youtube.com/**', '*://player.vimeo.com/video/**']);
      return ionGalleryConfigProvider.setGalleryConfig({
        action_label: 'Close',
        toggle: false,
        row_size: 2,
        fixed_row_size: false
      });
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
