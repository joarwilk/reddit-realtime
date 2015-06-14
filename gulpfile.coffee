gulp        = require 'gulp'
gutil       = require 'gulp-util'
coffeelint  = require 'gulp-coffeelint'
coffee      = require 'gulp-coffee'
concat      = require 'gulp-concat'
uglify      = require 'gulp-uglify'
clean       = require 'gulp-clean'
glob        = require 'glob'
runSequence = require 'run-sequence'
plumber     = require 'gulp-plumber'
shell       = require 'gulp-shell'
util        = require 'util'
istanbul    = require 'gulp-coffee-istanbul'
mocha       = require 'gulp-mocha'
reactify    = require 'reactify'
source      = require 'vinyl-source-stream'
buffer      = require 'vinyl-buffer'
browserify  = require 'browserify'
sourcemaps = require('gulp-sourcemaps');

chalk = require('chalk')

require("better-stack-traces").register({
  after: 3
  collapseLibraries: /node_modules/
})

sources =
  styles: './src/**/*.css'
  html: ['./src/*.html', './src/**/*.html', 'src/manifest.json']
  scripts: ['./src/scripts/**/!(main)*.coffee', './src/**/main.coffee']
  vendor: './src/scripts/vendor/*.js'
  js: './src/scripts/*.js'
  images: ['./src/**/*.jpg', './src/**/*.png']

destinations =
  css: 'build/css'
  html: 'build/'
  js: 'lib/'

watching = false

onError = (err) ->
  console.error chalk.red err.stack?.substr(0, 550)
  if watching
    this.emit('end')
  else
    process.exit(1)

gulp.task 'test-with-coverage', ->
  gulp.src(destinations.js + '/*.js')
  .pipe istanbul({includeUntested: true}) # Covering files
  .pipe istanbul.hookRequire()
  .on 'finish', ->
    gulp.src('test/*.coffee', {read: false})
    .pipe(mocha({
      reporter: 'spec'
      require: 'coffee-script/register'
      compilers: 'coffee:coffee-script'
    }))
    .pipe(istanbul.writeReports())

gulp.task 'test', ->
  util.print("\u001b[2J\u001b[0;0H")

  gulp.src('test/*.coffee', {read: false})
  .pipe(mocha({
    reporter: 'spec'
    compilers: 'coffee:coffee-script'
  }))
  .on('error', onError)

gulp.task 'style', ->
  gulp.src(sources.styles)
  .pipe(concat('main.css'))
  .pipe(gulp.dest(destinations.css))

gulp.task "views", ->
  gulp.src(sources.html)
  .pipe(gulp.dest("build/"))

gulp.task 'lint', ->
  gulp.src(sources.scripts)
  .pipe(coffeelint({
    "max_line_length": 80
  }))
  .pipe(coffeelint.reporter())

gulp.task 'src', ->
  gulp.src(sources.vendor)
  .pipe(gulp.dest(destinations.js + '/vendor'))
  gulp.src(sources.js)
  .pipe(gulp.dest(destinations.js))

  gulp.src(sources.scripts)
  .pipe(plumber())
  .pipe(coffee({bare: true}).on('error', ( -> )))
  .pipe(gulp.dest(destinations.js))

gulp.task 'images', ->
  gulp.src(sources.images)
    .pipe(gulp.dest('build/'))

gulp.task 'watch', ->
  watching = true

  gulp.watch sources.images, ['images']
  gulp.watch sources.styles, ['style']
  gulp.watch sources.scripts, ['chrome']
  gulp.watch sources.js, ['lint', 'src']
  gulp.watch sources.vendor, ['lint', 'src']
  gulp.watch sources.html, ['views']
  #gulp.watch 'test/*.coffee', ['test'] - Should this be included?

gulp.task 'watch-test', ->
  watching = true

  gulp.watch sources.scripts, ['test']
  gulp.watch sources.js,      ['test']
  gulp.watch 'test/*.coffee', ['test']

  runSequence 'test'

gulp.task 'chrome', ['lint', 'src'], ->
  b = browserify({
    entries: glob.sync('./lib/**/*.js'),
    debug: true,
    transform: [reactify]
  });

  gulp.src('./src/chrome/**/*.*')
    .pipe(gulp.dest('build/'))

  return b.bundle()
    .pipe(source('app.js'))
    .pipe(buffer())
    .pipe(sourcemaps.init({loadMaps: true}))
        .pipe(uglify())
        .on('error', gutil.log)
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest('./build/'));


gulp.task 'clean', ->
  gulp.src(['build/', 'lib/', 'dist/'], {read: false})
  .pipe(clean())

gulp.task 'build', ->
  runSequence 'clean', ['style', 'lint', 'src', 'views', 'images']

gulp.task 'default', ['build', 'watch']
