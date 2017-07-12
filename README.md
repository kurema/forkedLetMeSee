# forkedLetMeSee
forked version of let me see...

## 概要
電子辞書オープンラボ・かずひこ様などが作成したlet me see...のフォークです。  
let me see...はEP-WINGをcgiで実行しブラウザから検索を可能にするソフトウェアです。  
開発はかなりの昔に止まっているように見えます。

フォークと言ってもまずは最近の環境で動くようにして、細かな機能を追加する程度でしょう。  
ただ、私が作った訳ではないよという事と開発を引き継ぐようなつもりではないよと言いたかっただけ。

## 変更内容
最初のコミットが最新のCVSから拾ってきた内容です。

20170711  
とりあえず、FILE::OPENに文字コード指定がないとエラーを吐くので指定しました。  
requireでローカルファイルを参照する際に"./"が必要になったようなので修正しました。  
これで現時点では機能しました。

20170713  
XML出力に対応しました。通常のアドレスにoutput=xmlを足せばいいです。  
本文はhtmlのままですしタグ対応ミスがあるかもしれませんので、デシリアライズには期待できません。

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
### 参考
* 公式ページ：http://openlab.ring.gr.jp/edict/letmesee/index.html.ja
* 大変分かりやすい手順解説：https://skalldan.wordpress.com/2013/03/11/raspberry-pi-で遊ぶ-9-辞書サーバーとして/
## ToDo
* XMLでデータを取得しAndroidで見れるようにしたい。  
* あと画面表示をもうちょっと現代風にしたいかな。
* スマホ対応・レスポンシブデザイン。
