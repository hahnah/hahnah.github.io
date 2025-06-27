---
title: "[Elm] 基本コマンド"
# image: "/images/tech-blog/slug/image.jpg"
description: "プログラミング言語Elmの基本コマンドをまとめて紹介する。"
published: "2018-10-21"
updated: "2025-06-27"
category: "tech"
tags: ["elm"]
---

対象バージョン： Elm 0.19

### init

```
$ elm init
```

コマンドを実行するとカレントディレクトリに以下が作成される。

- `src`フォルダ
- `elm.json`ファイル (任意。作成するかどうか聞かれるが、基本的に Yes でいい)

プロジェクトディレクトリの作成まではしてくれないので、予め作っておく。  
(`elm init <プロジェクト名>`のような使い方は出来ない)

```
$ mkdir <プロジェクト名>
$ cd <プロジェクト名>
$ elm init
```

### repl

```
$ elm repl
```

コマンドを実行するとターミナル上で REPL が始まる。  
変数や関数を作ってちょっとした動作を試したいとき、型を確かめたいときなどに使う。

以下のように、対話的なインターフェースでプログラムを動かす。

```
$ elm repl
---- Elm 0.19.0 ----------------------------------------------------------------
Read <https://elm-lang.org/0.19.0/repl> to learn more: exit, help, imports, etc.
--------------------------------------------------------------------------------
> "Hello " ++ "Elm"
"Hello Elm" : String
>
```

REPL から抜けるときは`:exit`と打つか、ctrl + c 。

```
> :exit
```

### install

```
$ elm install <package>
```

Elmパッケージをプロジェクトにインストールする。  
パッケージは [https://package.elm-lang.org/](https://package.elm-lang.org/) で検索できる。

```
$ elm install elm/http
=> elm/http のパッケージをインストールする
```

ちなみに、プロジェクトが依存する Elmパッケージは`elm.json`ファイルで確認できる。

### reactor

```
$ elm reactor
```

コマンドを実行すると、 elm ファイルをコンパイルして http://localhost:8000 表示するサーバーを立ててくれる。開発時の動作確認に用いる。

ちなみに、プロジェクトに変更を加えた際に`elm reactor`とわざわざ打ち直す必要はない。  
ブラウザでページをリロードするだけで変更が反映される。

##### オプション

- \-\-port=<port> : ポート番号を指定する (デフォルトは 8000)

```
$ elm reactor --port=8888
```

### make

```
$ elm make <elm-files>
```

`.elm`ファイルをコンパイルして`.html`または`.js`のファイルを作成する

```
$ elm make src/Mainl.elm
=> src/Main.elm をコンパイルして index.html を作成
```

##### オプション

- \-\-debug : タイムトラベリングデバッガーを有効にする (イベントを巻き戻して当時の状態とビューを確認できるようになる)
- \-\-optimize : 最適化を有効にする （軽量で高速なファイルにコンパイルされる）
- \-\-output=<output-file> : output されるファイル名を指定する
  ```
  $ elm make --output="module1.js" src/Module1.elm
  => src/Module1.elm をコンパイルして module1.js を作成
  ```

### diff

```
$ elm diff <package> <version> <version>
```

Elmパッケージの差分を確認する。APIの増減を教えてくれる。

```
$ elm diff elm/browser 1.0.0 1.0.1
No API changes detected, so this is a PATCH change.
```

```
$ elm diff arsduo/elm-ui-drag-drop 1.0.0 2.0.0
This is a MAJOR change.

---- ADDED MODULES - MINOR ----

    Dom.DragDrop


---- REMOVED MODULES - MAJOR ----

    Ui.DragDrop
```

### publish

```
$ elm publish
```

自分で作成した Elmパッケージを [https://package.elm-lang.org](https://package.elm-lang.org) に公開する。

公開するには以下のような条件を満たす必要があるらしい。

- `elm.json`に必要な情報が記載されていること
- ドキュメントファイルが用意されていること

「GitHubにソースがあること」「テストが書かれていること」など、他にも条件がありそう。私自身が publish する機会があれば調べてみる。

### bump

```
$ elm bump
```

[https://package.elm-lang.org](https://package.elm-lang.org) に公開した Elmパッケージをローカルで変更した際、セマンティックバージョニングのルールに基づいて、ローカルの Elmパッケージのバージョン情報を更新してくれる。

### \-\-help オプション {#help}

本記事では、あまり使わなさそうだと私が思ったオプションについては省略したが、  
`--help`を使えばそれらも含めて確認できるだろう。

```
$ elm --help
=> elm のコマンド一覧を教えてくれる
```

```
$ elm make --help
=> make コマンドの使い方やオプションについて教えてくれる
```
