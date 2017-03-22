console.log('Start');

var concat = require('gulp-concat');
var gulp = require('gulp');
var uglify = require('gulp-uglify');
watch = require('gulp-watch');


var appjs = [
             './public/javascripts/app.js',
             './public/javascripts/controller.js',
             './public/javascripts/service.js',
             './public/javascripts/router.js'
            ]


gulp.task('default', function() {
  gulp.src(appjs)
    .pipe(concat('app.min.js'))
    .pipe(uglify())
    .pipe(gulp.dest('./public/dist'))
});


gulp.task('watch', function () {
    gulp.watch('public/javascripts/*.js', ['default']);
});
