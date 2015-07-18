g	= require 'gulp'
$ = (require 'gulp-load-plugins')()
b	= require 'browser-sync'
reload = b.reload
buffer = require 'vinyl-buffer'
browserify = require 'browserify'
debowerify = require 'debowerify'
source = require 'vinyl-source-stream'
del = require 'del'

g.task 'browsersync', ['sass', 'coffee', 'html'], ->
  b
    server:
    	baseDir:'.tmp/'
  g.watch 'dev/coffee/**/*.coffee' , ['coffee']
  g.watch 'dev/sass/**/*.sass' , ['sass']
  g.watch 'dev/**/*.html' , ['html']
  g.watch 'test/models/*.coffee' , ['test']

g.task 'reload', ->
  reload()

g.task 'sass', ['fonts'], ->
  $.rubySass 'dev/sass/',
    # style:'compressed'
    loadPath:'bower_components/bootstrap-sass/assets/stylesheets/'
  .pipe $.plumber(errorHandler: $.notify.onError('<%= error.message %>'))
  # .pipe $.minifyCss()
  .pipe g.dest '.tmp/css'
  .pipe reload stream:true

g.task 'fonts', ->
  g.src ['bower_components/bootstrap-sass/assets/fonts/bootstrap/*']
  .pipe g.dest '.tmp/fonts/bootstrap'

g.task 'coffee', ['test'], ->
  browserify
    entries    : ['./dev/coffee/views/app.coffee']
    extensions : '.coffee'
    transform  : ['coffeeify', 'debowerify']
  .bundle()
  .pipe source 'app.js'
  .pipe buffer()
  # .pipe $.uglify()
  .pipe g.dest '.tmp/js'
  .pipe reload stream:true

g.task 'html', ->
  g.src 'dev/**/*.html'
  .pipe g.dest('.tmp')
  .pipe reload stream:true

g.task 'default', ['browsersync'], ->
  g.watch '.tmp/**/*', ['reload']

g.task 'clean', del.bind null, ['./.tmp']

g.task 'build', ['clean', 'sass', 'coffee', 'html'], ->
	g.src '.tmp/**/*'
	.pipe $.tar 'dist/calculator.tar'
	.pipe $.gzip()
	.pipe g.dest '.'

g.task 'test', ->
  browserify
    entries    : ['./test/models/app.coffee']
    extensions : '.coffee'
    transform  : ['coffeeify', 'debowerify']
  .bundle()
  .pipe source 'app.js'
  .pipe g.dest './test/models/'

  g.src './test/models/app.js'
  .pipe $.mocha reporter:'nyan'
