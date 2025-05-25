---
title: "Elm をこんな風に学んでいる"
image: "/images/tech-blog/2021-how-i-learned-elm/monkeys.avif"
description: "自分がどんな風にElmというプログラミング言語を学んできたか、何をみて情報を集めているかまとめてみる。Elm を学び始めた人の参考になれば幸いだ。"
published: "2021-11-16"
updated: "2025-05-25"
category: "tech"
tags: ["elm"]
---

## 公式ガイドで Elm を学び始める

まずは Elm 公式ガイド(日本語翻訳版) [https://guide.elm-lang.jp/](https://guide.elm-lang.jp/) に軽く目を通すのが良いだろう。

最初の数ページを読むだけでも以下の情報が得られる。

- Elm が何に重きを置いた言語なのか、どんな長所があるのか分かる
- REPL を通して Elm の基本文法を学べる
- The Elm Architecture という、 Elm の設計パターンに触れられる
- Elmで書かれたコードはどんな見た目をしているのかが分かる

さらに読み進めていくと、Elm と　JavaScript を相互作用させる用法や、複数のページから成る Web アプリケーションを作る方法なども載っている。

公式ガイドの序盤を軽く読みつつ、REPL で基本文法を確認したり、 公式のサンプルコード集 [https://elm-lang.org/examples](https://elm-lang.org/examples) を眺めたり、いじったりすれば Elm の雰囲気が掴めるかもしれない。

## 簡単なアプリを作ってみる

Elm の雰囲気が何となく分かったような、けどまだ分かってないようなところで、学習を始めた当時の自分は簡単なアプリを作ってみた。

標準ライブラリ(というか、プロジェクト初期時にすでにインストールされている Elm Packages)だけで作ることのできる、１ページだけの、非常に簡単なゲームなんかを作った。  
このとき、Elm Packages [https://package.elm-lang.org/](https://package.elm-lang.org/) のサイトでElmライブラリ(Elm Packages) の使い方を調べながら作っていったことで、ドキュメントの読み方も身についた。

ちにみに現在の最新である Elm 0.19.1 では、`elm/browser`, `elm/core`, `elm/html` という 3つの Elm Packages がプロジェクト初期化時にインストールされているが、これらのドキュメントは Elm Packages のページ [https://package.elm-lang.org/](https://package.elm-lang.org/) の右上 `Popular Packages` という欄に全てリンクがあるので、そこからアクセスできる。（画像の赤枠部分）

![Popular Packages](/images/tech-blog/2021-how-i-learned-elm/popular-packages.avif)

## 書籍を読む

日本語のElm本は２冊だけしかない。全部読めてしまうな。

- 「基礎からわかるElm」
  - [Amazon リンク](https://www.amazon.co.jp/dp/4863542224)
  - とても読みやすかった。入門書としておすすめできる。
- 「プログラミングElm ~安全でメンテナンスしやすいフロントエンドアプリケーション開発入門」
  - [Amazon リンク](https://www.amazon.co.jp/dp/4839970041)
  - 自分はまだ読めてない...今度読もう。

## Elm patterns を眺める

Elm patterns というサイトがある。 [https://sporto.github.io/elm-patterns/index.html](https://sporto.github.io/elm-patterns/index.html)

これは Elm で良いとされる様々なコーディングパターンが網羅的にまとめられたサイトだ。  
これを眺めるだけでもかなり学びになる。

## 誰かに教えてもらいたいとき

分からないことなどを X でつぶやいてみるといい。  
"Elm" というワードを含めていれば、誰かが気づいてくれて優しく教えてくれる。自分もお世話になった。

ElmJP の Discord で質問してみるのもいいだろう。beginners というチャンネルがあるので、そこで質問すると丁寧に教えてもらえる。  
公式ガイドの 「はじめに」 のページ下部に Discord サーバーの招待リンクがあるので、そこから参加できる。  
[https://guide.elm-lang.jp/](https://guide.elm-lang.jp/)

## 検索するとき

プロジェクト構成、Package 選定、ツール選定、ツールの導入方法など、知りたいことがたくさん出てくる。  
自分だいたい次のように情報を検索する。

### Elm Packages

最もお世話になるのは Elm Pcakeges だ。 [https://package.elm-lang.org/](https://package.elm-lang.org/)

ここを眺めれば Elm Package に関する大抵のことは分かるし、目当ての Package もたぶん見つかるだろう。

### Elm Discourse

Elm Discourse [https://discourse.elm-lang.org/](https://discourse.elm-lang.org/) は、Elm ユーザーや開発者たちが、Elm のプラクティスについてよく議論している場所だ。

Elm Package の選定に迷っている、なんてとき、自分はよく Elm Discouse での議論を漁り、他の人の意見に触れたりする。

### ググる 「Elm at」

Elm のプロジェクト構成や　Package 選定に悩んでいるときは 「Elm at」 なんてググったりする。Elmを使っている企業がどんなツールを使っているのか、なんてのも知れる。

- Elm at NoRedInk [https://juliu.is/elm-at-noredink/](https://juliu.is/elm-at-noredink/)
- Elm at Rakuten [https://engineering.rakuten.today/post/elm-at-rakuten/](https://engineering.rakuten.today/post/elm-at-rakuten/)
  - なんとこの記事には Elm at \* のリンク集がある。ありがたい。 [https://engineering.rakuten.today/post/elm-at-rakuten/#other-testimonies](https://engineering.rakuten.today/post/elm-at-rakuten/#other-testimonies)

### X で検索する

X でも時々検索する。ある Elm Package を使った感想や課題の共有だったり、記事の共有が見つかると嬉しい。

### Reddit

これもあるなーと思った。今度ここで検索してみよう。
Reddit [https://www.reddit.com/r/elm/](https://www.reddit.com/r/elm/)
