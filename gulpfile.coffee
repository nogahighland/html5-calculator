g	= require 'gulp'
$ = (require 'gulp-load-plugins')()
b	= require 'browser-sync'
reload = b.reload
buffer = require 'vinyl-buffer'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
del = require 'del'

g.task 'browsersync', ['sass', 'coffee', 'html'], ->
  b
    server:
    	baseDir:'.tmp/'
  g.watch 'dev/coffee/**/*.coffee' , ['coffee']
  g.watch 'dev/sass/**/*.sass' , ['sass']
  g.watch 'dev/**/*.html' , ['html']

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

g.task 'coffee', ->
  browserify
    entries : ['./dev/coffee/app.coffee']
    extensions : '.coffee'
    transform : ['coffeeify', 'debowerify']
  .bundle()
  .pipe source 'app.js'
  .pipe buffer()
  .pipe $.uglify()
  .pipe g.dest '.tmp/js'
  .pipe reload stream:true

g.task 'html', ->
  g.src 'dev/**/*.html'
  .pipe g.dest('.tmp')

g.task 'default', ['clean','browsersync'], ->
  g.watch '.tmp/**/*', ['reload']

g.task 'clean', del.bind(null, ['./.tmp'])

g.task 'build', ['clean', 'sass', 'coffee', 'html'], ->
	g.src '.tmp/**/*'
	.pipe $.tar 'dist/calculator.tar'
	.pipe $.gzip()
	.pipe g.dest '.'
