---
title: "RailsでMySQLのマイグレーションしたらschema.rbのcollateが変わっちゃうんだが？"
# image: "/images/tech-blog/slug/image.jpg"
description: "DBマイグレーション時にschema.rbのcollateが変わる問題について調べた。"
published: "2023-08-23"
updated: "2025-04-24"
category: "tech"
tags: ["mysql", "database"]
---

自分のローカル環境でDBテーブルのスキーマ更新用マイグレーションファイルを作って `rails db:migrate` した。

schema.rb を見るとそのテーブルの `COLLATE="utf8mb4_general_ci"` だった箇所が `COLLATE="utf8mb4_0900_ai_ci"` に書き変わってた。

schema.rb のサンプルを示すと、
↓これが

```rb
ActiveRecord::Schema.define(version: 2023_08_23_012345) do
  create_table "users", options="CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci" do |t|
    t.string "name"
  end
end
```

↓こうなる (COLLATEの箇所が変わっちゃう)

```rb
ActiveRecord::Schema.define(version: 2023_08_23_012345) do
  create_table "users", options="CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci" do |t|
    t.string "name"
  end
end
```

本記事は、このときに一体何が起こっているのか、どう対処すればいいのか、そもそもCOLLATEとは何なのか、を調べたものだ。

前提として、以下の環境だった:

- Ruby 2系
- Ruby on Rails 5系
- DBはMySQL 8系
- DBは以前 MySQL 5系だったが、あるとき8系にアップデートした
- ローカルの開発環境はDockerコンテナ上に構築される

## そもそも collate (collation) って何？

collationが何なのかすらよく分かってなかったのでそこから調べた。

collationとは「照合順序」を表す用語だ。  
要は文字の比較やソートのルールを表す。

２つの文字が一致するか、どちらが大きい/小さい (並び順として先/後)　かというのを決めている。

### collation による違い

例えば、あるカラム値が「Alice」のレコードを検索するクエリが実行される際に、collationで定められた比較ルールに則って該当レコードが見つけ出される。

あるcollationでは「Alice」のレコードだけがヒットするが、別のcollationでは大文字小文字の区別がされずに「alice」や「AliCE」もヒットしたりする。

日本語の「しよう」と「ショウ」とが区別されるかどうかも、collationによって異なる。

詳しくはcollationによる違いを検証している記事がたくさんあるのでそちらを参照のこと：

- [https://zenn.dev/zoeponta/articles/090c68ba820a24](https://zenn.dev/zoeponta/articles/090c68ba820a24)
- [https://blog.siwa32.com/mysql_collation/](https://blog.siwa32.com/mysql_collation/)

今回のきっかけとなった utf8mb4_general_ci と utf8mb4_0900_ai_ci を比較すると、次のようになるらしい。  
([https://zenn.dev/zoeponta/articles/090c68ba820a24](https://zenn.dev/zoeponta/articles/090c68ba820a24) より抜粋)

| 照合順序           | はは ≠ ハハ | びょういん ≠ びよういん | はは ≠ ぱぱ | ハハ ≠ ﾊﾊ | A ≠ a | &#x1f363; ≠ &#x1f37a; | 備考        |
| ------------------ | ----------- | ----------------------- | ----------- | --------- | ----- | --------------------- | ----------- |
| utf8mb4_general_ci | T           | T                       | T           | T         | F     | F                     | 5.7 default |
| utf8mb4_0900_ai_ci | F           | F                       | F           | F         | F     | T                     | 8.0 default |

上の表での見方はこうだ:

- T: 異なる文字列とみなされる
- F: 同じ文字列とみなされる

`utf8mb4_0900_ai_ci` だと日本語文字の比較に難ありなことがわかる。  
`utf8mb4_general_ci` の方が日本語文字を扱う場合は良さそう。

`utf8mb4_general_ci` では &#x1f363; と &#x1f37a; の絵文字が同じものとみなされる点にも目がいく。これは他の絵文字であってもそうなる。  
この問題は「寿司ビール問題」などと呼ばれるらしい。

### charset と collation の関係

どのcollationを使えるかはcharsetとも関係している。  
最初に示したschema.rbを見ると、 `CHARSET=utf8mb4` とあるが、そのテーブルの charset は `utf8mb4` になっている。  
使えるcollationとしてはutf8mb4文字セット用のcollationのみであり、`utf8mb4_`で始まるものがそうだ。

```rb
  create_table "users", options="CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci" do |t|
```

### collationは何に対して設定されるのか

今回見た shema.rb の例だとテーブルに対する collation の設定が見られた。  
しかしMySQL8はテーブル以外にも、さまざまにcollation設定を持っているようだ。  
以下のcollation関係のパラメーターがMySQLにはある:

- collation_connection
- collation_database
- collation_server
- default_collation_for_utf8mb4

リンク先にこれらの説明がある。  
[https://dev.mysql.com/doc/refman/8.0/ja/charset-connection.html](https://dev.mysql.com/doc/refman/8.0/ja/charset-connection.html)

`default_collation_for_utf8mb4`については上記リンクには説明がないが、

> 何このパラメーター、と思ったら、 utf8mb4 のデフォルトコレーションが utf8mb4_general_ci (MySQL 5.7とそれ以前) から utf8mb4_0900_ai_ci (MySQL 8.0)に変わったことに対する経過措置っぽかった。
> これを utf8mb4_general_ci にセットしておくと、コレーションを指定せずに utf8mb4 を使った時に今まで通り utf8mb4_general_ci を使ってくれるということ。

ということらしい。([https://yoku0825.blogspot.com/2018/05/defaultcollationforutf8mb4.html](https://yoku0825.blogspot.com/2018/05/defaultcollationforutf8mb4.html) より)

一応次のページに `default_collation_for_utf8mb4` の説明がある。  
[https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_collation_for_utf8mb4](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_collation_for_utf8mb4)

## なぜ起こったのか

起こった問題をもう一度思い出す。

> 自分のローカル環境でDBテーブルのスキーマ更新用マイグレーションファイルを作って `rails db:migrate` した。
>
> schema.rb を見るとそのテーブルの `COLLATE="utf8mb4_general_ci"` だった箇所が `COLLATE="utf8mb4_0900_ai_ci"` に書き変わってた。

このテーブルはもともと自分以外の他の人が作成したものだった。  
ここまでで学んだ知識から、自分と、当時のその人の環境でどのcollationを使う設定かが違うためだろうということが推測される。

より具体的な仮説は以下のようになる:

- MySQL 5系で開発していた時代には `utf8mb4_general_ci` がデフォルトなのでそちらが適用されいた。しかし MySQL 8系にアップデートして以降では新たなデフォルトの `utf8mb4_0900_ai_ci` でマイグレーションがされるようになったことが原因で、今回の事象が起こっている
- ローカルでは Docker 環境で開発しているのだが、Docker を使わずにホストマシン上に直接環境構築しているケースもあるだろう。そういった場合にはどちらか(もしくは両方)の環境でcollation関係のパラメーターに差異があることが考えられる
- また、途中でDockerを導入していた場合は、導入の前後でcollation関係のパラメーターに差異が出た可能性がある

## で、どうしたらいいの？

まず、collationとして何を採用すべきかという問題があり、それを決めた後にそのcollationになるように変更することになる。

日本語を扱うので `utf8mb4_general_ci` の方が `utf8mb4_0900_ai_ci` よりも好ましいだろう。  
ただ、他の collation にも目を向けると `utf8mb4_0900_as_cs` や `utf8mb4_ja_0900_as_cs_ks` の方が良さそうだ。  
(比較は [https://zenn.dev/zoeponta/articles/090c68ba820a24](https://zenn.dev/zoeponta/articles/090c68ba820a24))

### ちなみに全てのテーブルで collation　は統一した方がいいのだろうか？

答えは大抵のケースで「YES」だ。

統一されていないと、次の問題が起こるらしい。  
([https://gihyo.jp/dev/serial/01/mysql-road-construction-news/0157](https://gihyo.jp/dev/serial/01/mysql-road-construction-news/0157) より)

> テーブル間でcollationが異なるときに起こる問題について紹介したいと思います。その場合、JOINのときに結合キーでインデックスが効かないためクエリが遅くなる可能性があります。

なので全てのテーブルで同じcollationを使うようにしたい。

### これまで全テーブルで `utf8mb4_general_ci` を使ってきたが、`utf8mb4_0900_as_cs`などのより良さそうなものに変えた方がいいだろうか?

そうした方がいいと思ったのだが、ChatGPTに聞いてみたら結構脅されたので、大人しく元々のcollation `utf8mb4_general_ci`にしようかな...  
(知識不足で真偽判定はできず)

![collation変換のリスク](/images/tech-blog/2023-mysql8-collation/ask-about-collation-changing.avif)

### 解決方法

これでいけるんじゃないか?(まだ試してない)

1. `default_collation_for_utf8mb4` に `utf8mb4_general_ci`をセットすることで、以降のスキーマ更新でこのcollatioinが使われるようにする

   - 今回の場合は docker-compose.yml に以下の設定で良さそう(いろいろ省略してる)。ホストマシン上に直接構築してる場合は個別にセットする必要あり。
     ```yml
     services:
       db:
         command: mysqld --default-collation-for-utf8mb4=utf8mb4_general_ci
     ```

2. collationを変えたいテーブル(今回の場合はusers) の collation を `utf8mb4_general_ci` に変更する

   - (Railsの場合) collationを変えたいテーブルに対して、空でいいのでマイグレーションファイルを作成し `rails db:migrate` でいけるんじゃないだろうか
   - (Rails関係なく対処する場合) MySQLのコマンドで対象テーブルのcollationを変更する
     ```
     mysql> SET USERS utf8mb4 COLLATE utf8mb4_general_ci;
     ```

懸念としては、以下のパラメーターについても `utf8mb4_general_ci`に変更すべきものがないかどうか:

- collation_connection
- collation_database
- collation_server

#### P.S.

コメントで教えてもらったのですが、
`SET PERSIST default_collation_for_utf8mb4=utf8mb4_general_ci;`のようにするといいみたいです。

> `–default-collation-for-utf8mb4=utf8mb4_general_ci` というオプションは存在しません。
>
> `SET PERSIST default_collation_for_utf8mb4=utf8mb4_general_ci;` のように永続化するシステム変数として定義することで、新しく作成されるテーブルがCHARSET指定がない場合`utf8mb4_general_ci` を用いるようになります。

## collationについてもっと知りたい場合に参考になる記事

- [https://kazuhira-r.hatenablog.com/entry/2021/05/08/232717](https://kazuhira-r.hatenablog.com/entry/2021/05/08/232717)
