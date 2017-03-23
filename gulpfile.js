console.log('Start');

var concat = require('gulp-concat');
var gulp = require('gulp');
var uglify = require('gulp-uglify');
watch = require('gulp-watch');


var appjs = [
             './public/dist/js/app.js',
             './public/dist/js/controller.js',
             './public/dist/js/service.js',
             './public/dist/js/router.js'
            ]


gulp.task('default', function() {
  gulp.src(appjs)
    .pipe(concat('app.min.js'))
    .pipe(uglify())
    .pipe(gulp.dest('./public/dist/js'))
});


gulp.task('watch', function () {
    gulp.watch('public/dist/js/*.js', ['default']);
});
