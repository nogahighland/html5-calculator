# Apple風計算機(β)

![Screenshot](./images/screenshot.png 'Screenshot')

## 概要

- 主にビルドシステムの学習で作ったWebアプリです
- Gulp + Browseryfy + CoffeeScript + Sassで開発
  - フレームワークはBackbone.js...

## 使い方

- Macの通知センター？に追加できる電卓と同じキー操作にしています。
- ほぼ見たままキーボードに打ち込むか数字盤をクリックして頂ければ大丈夫ですが、いくつかイレギュラーなキーバインディングになっています。
  - 削除 (D): deleteキーの検知ができなかったので、ご指摘頂きたいです。
  - ± (I): 入力中の数値のプラスマイナス入れ替えです。Invertの略でIにしています。

## TODO

- スタイルをモバイルにも最適化したい
- タッチイベントの正しい処理(touchendでボタン外だったらfireしない、など)
- 文字数が多くなった場合の自動レイアウト調整
- React.jsで作ってみたかった
- gulpタスクの分割

## 動かし方

### 前提

- [Node.js](https://nodejs.org/)がインストールされていること, npm
- bower, gulpがグローバルインストールされていること

```sh
$ npm install -g bower
$ npm install -g gulp
```
- sassがインストールされていること(Rubyがインストールされていることが前提となります)

```sh
$ gem install sass
```

### セットアップ

```sh
# package.jsonのあるディレクトリで実行
$ npm install && bower install
```

### 起動
```sh
$ gulp
# browsersyncでブラウザが自動的に起動します。
```

### デバッグ

そのままではソースが圧縮されてしまっているので、[gulp.coffee](./gulpfile.coffee)の該当箇所をコメントアウトして再度実行すると、開発者ツールで見やすくなります。

- JavaScript

```coffee
g.task 'coffee', ->
  browserify
    entries    : ['./dev/coffee/views/app.coffee']
    extensions : '.coffee'
    transform  : ['coffeeify', 'debowerify']
  .bundle()
  .on 'error', $.util.log
  .pipe source 'app.js'
  .pipe buffer()
  .pipe $.uglify() # ←ここ
  .pipe g.dest '.tmp/js'
  .pipe reload stream:true
```

- CSS

```coffee
g.task 'sass', ['fonts'], ->
  $.rubySass 'dev/sass/',
    style:'compressed' # ←ここ
    loadPath:'bower_components/bootstrap-sass/assets/stylesheets/'
  .pipe $.plumber(errorHandler: $.notify.onError('<%= error.message %>'))
  .pipe $.minifyCss() # ←ここ
  .pipe g.dest '.tmp/css'
  .pipe reload stream:true
```
