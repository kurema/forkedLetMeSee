# forkedLetMeSee
forked version of let me see...

[Original README](edict-devel/letmesee/README)

## 概要
電子辞書オープンラボ・かずひこ様などが作成したlet me see...のフォークです。  
let me see...はEP-WINGをcgiで実行しブラウザから検索を可能にするソフトウェアです。  
2003年頃まで開発されていたものですが、こちらで若干の改良を行っています。

masterブランチはデザインや仕様の変更が入っています。  
元プロジェクトと同様の体験をお望みの場合、originalブランチを参照してください。

## 利用方法
事前にEPWing辞書が必要です。各辞書のフォルダを``conf/letmesee.conf``に登録する必要があるので少し面倒です。

### Docker
```bash
$ git clone https://github.com/kurema/forkedLetMeSee.git
$ cd forkedLetMeSee
$ nano docker-compose.yml
$ nano conf/letmesee.conf
$ sudo docker-compose up -d
```

### Ubuntu Server
```bash
$ sudo apt-get ruby ruby-dev eb-utils libeb16-dev ispell apache2
$ # ここでApache関係の設定をする。
$ sudo nano /etc/apache2/apache2.conf #Enable CGI
$ git clone https://github.com/kubo/rubyeb19.git
$ cd rubyeb19
$ ruby extconf.rb
$ make
$ sudo make install
$ cd ..
$ gem install iconv
$ git clone https://github.com/kurema/forkedLetMeSee.git
$ cd forkedLetMeSee/edict-devel/letmesee
$ # .htaccessではなくApache側の設定を変更しても良し (次3行)
$ cp dot.htaccess .htaccess
$ nano .htaccess #外部アクセスを制限
$ sudo a2enmod rewrite
$ nano letmesee.conf
$ sudo cp -a . /var/www/letmesee
$ sudo chown -R www-data:www-data /var/www/letmesee
$ sudo chmod 755 /var/www/letmesee/*.rb
```

[外部記事](https://skalldan.wordpress.com/2013/03/11/raspberry-pi-%E3%81%A7%E9%81%8A%E3%81%B6-9-%E8%BE%9E%E6%9B%B8%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC%E3%81%A8%E3%81%97%E3%81%A6/)

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
* RubyEB(EBライブラリのRubyラッパー)：https://github.com/kubo/rubyeb19
* EBライブラリ：リンク切れ
