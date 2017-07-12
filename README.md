# forkedLetMeSee
forked version of let me see...

## 概要
電子辞書オープンラボ・かずひこ様などが作成したlet me see...のフォークです。  
let me see...はEP-WINGをcgiで実行しブラウザから検索を可能にするソフトウェアです。  
開発はかなりの昔に止まっているように見えます。

フォークと言ってもまずは最近の環境で動くようにして、細かな機能を追加する程度でしょう。  
ただ、私が作った訳ではないよという事と開発を引き継ぐようなつもりではないよと言いたかっただけ。

## originalブランチについて
このブランチは私の好みを入れないバグ修正のみのブランチです。デザイン変更とかね。  
つまりバックポートです。  
まだCVSが生きてるんだからメールか何かでプルリクエストでもおくるべきだったかもしれない。

なおこのブランチは実は現時点で動作検証していません。  
大した修正はないのでまず動くだろうと思います。

## 変更内容
最初のコミットが最新のCVSから拾ってきた内容です。

20170711  
とりあえず、FILE::OPENに文字コード指定がないとエラーを吐くので指定しました。  
requireでローカルファイルを参照する際に"./"が必要になったようなので修正しました。  
これで現時点では機能しました。

20170712  
* 装飾の入れ子を想定していないバグを修正。
* XHTML対応に修正。

## 元プロジェクトについて
### 開発者
[edict-devel/letmesee/AUTHORS](edict-devel/letmesee/AUTHORS)参照。
### ライセンス
GPLライセンスです。
[edict-devel/letmesee/COPYING](edict-devel/letmesee/COPYING)参照。
### 取得方法
```
$ cvs -d :pserver:guest@openlab.jp:/circus/cvsroot login
CVS password: guest
$ cvs -d :pserver:guest@openlab.jp:/circus/cvsroot co edict-devel/letmesee
```
## ToDo
XMLでデータを取得しAndroidで見れるようにしたい。  
あと画面表示をもうちょっと現代風にしたいかな。
