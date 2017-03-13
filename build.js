console.log('Start');

var concat = require('gulp-concat');
var gulp = require('gulp');
var uglify = require('gulp-uglify');


gulp.task('default', function() {
  gulp.src(['./public/javascripts/app.js', './public/javascripts/controller.js'])
    .pipe(concat('all.js'))
    //.pipe(uglify())
    .pipe(gulp.dest('./public/dist'))
}, function(er){

    console.log(er);

});
