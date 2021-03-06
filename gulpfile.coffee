g	= require 'gulp'
$ = (require 'gulp-load-plugins')()
b	= require 'browser-sync'
reload = b.reload
buffer = require 'vinyl-buffer'
browserify = require 'browserify'
debowerify = require 'debowerify'
source = require 'vinyl-source-stream'
del = require 'del'

# コンパイルとブラウザ起動
g.task 'browsersync', ['sass', 'coffee', 'html'], ->
  b
    server:
    	baseDir:'.tmp/'
  g.watch './dev/coffee/**/*.coffee', ['coffee']
  g.watch './test/models/*.coffee', ['test']
  g.watch './dev/sass/**/*.sass', ['sass']
  g.watch './dev/**/*.html', ['html']

# ブラウザのリロード
g.task 'reload', ->
  reload()

# sassコンパイル
g.task 'sass', ->
  $.rubySass 'dev/sass/',
    style:'compressed'
    loadPath:'bower_components/bootstrap-sass/assets/stylesheets/'
  .pipe $.plumber(errorHandler: $.notify.onError('<%= error.message %>'))
  .pipe $.minifyCss()
  .pipe g.dest '.tmp/css'
  .pipe reload stream:true

# coffeeスクリプトのコンパイル
g.task 'coffee', ->
  browserify
    entries    : ['./dev/coffee/views/app.coffee']
    extensions : '.coffee'
    transform  : ['coffeeify', 'debowerify']
  .bundle()
  .on 'error', $.util.log # リリース時はどうする？
  .pipe source 'app.js'
  .pipe buffer()
  .pipe $.uglify()
  .pipe g.dest '.tmp/js'
  .pipe reload stream:true

# HTMLの移動
g.task 'html', ->
  g.src 'dev/**/*.html'
  .pipe g.dest('.tmp')
  .pipe reload stream:true

# コンパイル→ブラウザ起動をするデフォルトタスク
g.task 'default', ['browsersync'], ->
  g.watch '.tmp/**/*', ['reload']

# 作業ディレクトリのクリーン
g.task 'clean', del.bind null, ['./.tmp', './test/models/app.js']

# プロダクションリリース版のtar.gz作成
g.task 'build', ['clean', 'sass', 'coffee', 'html'], ->
	g.src '.tmp/**/*'
	.pipe $.vinylZip.dest('dist/calculator.zip')

g.task 'watch:test', ->
  g.watch './test/**/*.coffee', ['test']

# テストのみの実行
g.task 'test', ->
  browserify
    entries    : ['./test/models/figure.coffee', './test/models/app.coffee']
    extensions : '.coffee'
    transform  : ['coffeeify', 'debowerify']
  .bundle()
  .on 'error', $.util.log # リリース時はどうする？
  .pipe source 'test.js'
  .pipe g.dest './test/models/'
  .on 'end', ->
    g.src './test/models/test.js'
    .pipe $.mocha reporter:'spec'
    .on 'error', ->
      # $.util.log
