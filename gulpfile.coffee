gulp        = require 'gulp'
gutil       = require 'gulp-util'
stylus      = require 'gulp-stylus'
coffeelint  = require 'gulp-coffeelint'
coffee      = require 'gulp-coffee'
concat      = require 'gulp-concat'
uglify      = require 'gulp-uglify'
clean       = require 'gulp-clean'
gulp        = require 'gulp'
runSequence = require 'run-sequence'
plumber     = require('gulp-plumber');

istanbul    = require('gulp-coffee-istanbul')
mocha       = require('gulp-mocha');

sources =
  styles: './app/**/*.styl'
  html: ['./app/*.html', './app/**/*.html', 'app/manifest.json']
  scripts: ['./app/**/!(main)*.coffee', './app/**/main.coffee']
  vendor: './app/scripts/vendor/*.js'
  js: './app/scripts/*.js'
  images: ['./app/**/*.jpg', './app/**/*.png']

destinations =
  css: 'dist/css'
  html: 'dist/'
  js: 'dist/js'

gulp.task 'test', ->
  gulp.src(sources.scripts)
  .pipe istanbul({includeUntested: true}) # Covering files
  .pipe istanbul.hookRequire()
  .on 'finish', ->
    gulp.src('test/*.coffee', {read: false})
    .pipe(mocha({
      reporter: 'spec'
      compilers: 'coffee:coffee-script'
    }))
    .pipe(istanbul.writeReports())


gulp.task 'style', ->
  gulp.src(sources.styles)
  .pipe(stylus().on('error', gutil.log))
  .pipe(concat('main.css'))
  .pipe(gulp.dest(destinations.css))

gulp.task "views", ->
  gulp.src(sources.html)
  .pipe(gulp.dest("dist/"))

gulp.task 'lint', ->
  gulp.src(sources.scripts)
  .pipe(coffeelint({
    "max_line_length": 131
  }))
  .pipe(coffeelint.reporter())

gulp.task 'src', ->
  gulp.src(sources.vendor)
  .pipe(gulp.dest('dist/js/vendor'))
  gulp.src(sources.js)
  .pipe(gulp.dest(destinations.js))

  gulp.src(sources.scripts)
  .pipe(plumber())
  .pipe(coffee({bare: true}).on('error', ( -> )))
  .pipe(concat('app.js'))
  .pipe(gulp.dest(destinations.js))

gulp.task 'images', ->
  gulp.src(sources.images)
    .pipe(gulp.dest('dist/'))

gulp.task 'watch', ->
  gulp.watch sources.images, ['images']
  gulp.watch sources.styles, ['style']
  gulp.watch sources.scripts, ['lint', 'src']
  gulp.watch sources.js, ['lint', 'src']
  gulp.watch sources.vendor, ['lint', 'src']
  gulp.watch sources.html, ['views']
  gulp.watch 'test/*.coffee', ['test']

gulp.task 'clean', ->
  gulp.src(['dist/'], {read: false}).pipe(clean())

gulp.task 'build', ->
  runSequence 'clean', ['style', 'lint', 'src', 'views', 'images']

gulp.task 'default', ['build', 'watch']
