---
title: "elm-pages-blog-template | GitHubとMarkdownで記事管理するブログサイトテンプレートをElmで作った"
image: "/images/tech-blog/2025-elm-pages-blog-template/elm-pages-blog-template.avif"
description: "ブログサイトを構築のテンプレートを elm-pages で作りました。よければ使ってみてください。"
published: "2025-05-22"
updated: "2025-05-24"
category: "tech"
tags: ["elm-pages-blog-template", "elm", "elm-pages"]
---

## elm-pages-blog-template を作った

[elm-pages-blog-template](https://github.com/hahnah/elm-pages-blog-template)は、ブログサイトを作るための Elm のテンプレートです。  
ブログサイトは elm-pages によって静的サイトとして生成されます。

主な特徴としては:

- GitHubでサイトのソースコードとともに記事コンテンツも管理する(CMSは介在しない)
- Markdownで記事を記述
- 1つのサイト内で、カテゴリーの異なる複数ブログを運用可能
- Elm + Tailwind CSS で見た目をカスタマイズしたり、ブログ以外のページを追加したりでき、拡張性が高い

ブログのカテゴリーはデフォルトでテックブログとライフブログの2つが用意されていますが、簡単なコードの追加/削除で増やすことも減らすこともできます。カテゴリーの変更ももちろんできます。

### elm-pages-blog-template を作った動機

私は元々テックブログを運用しています。  
それはレンタルサーバー上に立てたWordPressで構築されています。

それについて以下の不満があり、[elm-pages-blog-template](https://github.com/hahnah/elm-pages-blog-template) を作成するに至りました:

- レンタルサーバーの運用コストが高い
- WordPressとプラグインをバージョンアップし続けるのが思った以上に面倒だった
- 記事をGit, GitHubで管理したい
- テックブログだけでなくライフブログも同一サイトで運用したくなったが、そこまでの拡張性がない(PHPスキルがないとも言えるが)
- 自分が例え死んでもサイトが残るようにしたいのでこの運用から脱却したい
  - 補足: 死ぬとレンタルサーバーやドメインの支払いが滞ってサイトが消滅する
  - つまり: 無料で運用できる静的サイトとして作り直したいということ

以上が主な動機です。  
他にも、「折角作るなら他の人も簡単に使えるようなテンプレートを用意したい」という思いもありました。  
それもあり、自分のサイトを作る前段階として elm-pages-blog-template を作成するに至りました。

## elm-pages-blog-template の機能

私が作った [elm-pages-blog-template](https://github.com/hahnah/elm-pages-blog-template) は、[elm-pages-blog-starter](https://github.com/kraklin/elm-pages-blog-starter) からForkして機能を追加しています。

以下に主な機能を列挙します。
elm-pages-blog-template で追加した機能は、elm-pages-blog-starter にはないものです。
その機能には「➕」アイコンをつけて示しています。

| 機能分類   | 機能                                          |
| ---------- | --------------------------------------------- |
| サイト構成 | 静的サイトとしてビルド                        |
|            | ➕ テックブログとライフブログを1サイトで運用  |
| ページ表示 | 記事ページ                                    |
|            | 記事一覧ページ                                |
|            | タグごとの記事一覧ページ                      |
|            | ➕ カテゴリー別の記事一覧ページ               |
|            | ➕ 全カテゴリーの記事一覧ページ(トップページ) |
|            | Aboutページ                                   |
| 記事管理   | 記事をMarkdownで記述                          |
|            | 記事にカバー画像を設定可能                    |
|            | 記事にタグを設定可能                          |
|            | 記事に執筆ステータスを設定可能                |
|            | 記事に複数の著者を設定可能                    |
|            | 記事の公開日を設定可能                        |
| (かつSEO)  | ➕ 記事の更新日を設定可                       |
|            | ➕ 記事のカテゴリーを設定可能(テックorライフ) |
| 著者管理   | 著者情報をMarkdownで記述                      |
|            | 著者にプロフィール画像を設定可能              |
|            | 著者にSNSリンクを設定可能                     |
| SEO        | 記事の公開日を設定可能                        |
|            | ➕ サイトマップ生成                           |
|            | ➕ 構造化データ                               |
| OG画像     | ➕ 各種SNS, X用のOG画像                       |

## フォルダ構成と elm-pages-blog-template の使い方

```
/
┣ app/
┃  ┗ Route/
┃     ┗ NewPage.elm # 新しくページを作る場合はここにモジュールを追加するのが必須
┃
┣ src/
┃  ┣ Content/
┃  ┃  ┗ NewPage.elm # ページのコンテンツ部分はここに記述(もしあれば)
┃  ┃
┃  ┗ Layout/
┃     ┗ NewPage.elm # ページの見た目の部分はここに記述
┃
┣ content/
┃     ┗ tech-blog/
┃        ┗ 2025-sample-post.md # 記事ファイル
┗ public/
   ┗ images/
      ┗ tech-blog/
        ┗ 2025-sample-post/
           ┗ sample-image.avif # 記事に使う画像ファイル

```

### 記事の書き方

テックブログであれば、`content/tech-blog/` 配下に、ライフブログであれば `content/life-blog/` 配下にMarkdownファイルで記事を記述します。  
記事のテンプレートファイル `0000-template.md` をコピペして書き始めるといいでしょう。

記事中で使う画像は、`public/images/tech-blog/<slug>/` 配下に配置します(tech-blogの場合)。`<slug>`の部分は記事のファイル名と同じにします。

記事を公開状態にするには、`.md`ファイルの `status: "draft"` を削除してください。

### 新しいページを作る方法

Aboutページなどと同様に、`app/Route/` 配下にモジュールを用意するとルーティングされます。  
コンテンツに関するコードは `src/Content/` 配下に、見た目に関するコードは `src/Layout/` 配下に用意するといいでしょう。  
また、レイアウトや装飾には Tailwind CSS を使います。

## 良ければ elm-pages-blog-template を使ってみてください

私自身のサイトはすでに [elm-pages-blog-template](https://github.com/hahnah/elm-pages-blog-template) を元にして構築できました。
以下がそのサイトです。

[Hahnah Chronicle](https://hahnah.github.io/) ([Source Code](https://github.com/hahnah/hahnah.github.io))

![Hahnah Chronicle](/images/tech-blog/2025-elm-pages-blog-template/hahnah-site.avif)

[elm-pages-blog-template](https://github.com/hahnah/elm-pages-blog-template) は作者の私自身が一番のユーザーとしてずっと利用し続けます。
私自身の利用から見えてきた問題や改善点については、常にメンテナンスしていますので安心してご利用ください。

## 余談: elm-pages-blog-template 作った時の苦労話

### 1. GitHub Pages の仕様?に悩まされた

記事につけるタグを日本語にしたいと思っていました。
developmentモードの時や Netlify へのデプロイでは日本語タグで何の問題もなかったです。
しかし、GitHub Pages にデプロイすると、日本語タグのページが404エラーになってしましました。

調べたところ GitHub Pages はマルチバイト文字を含むURLをきちんとサポートしているようですが、GitHub Pages でしか起こらない問題なので謎です。

この点に関しては申し訳ないですが諦めました。  
Netlify など他のホスティングサービスなら日本語のタグが使えたりするので、そちらも視野に入れてみてください。

### 2. elm-pages のビルドモードによる挙動の違いに悩まされた

#### 例: productionモードでビルドした時に、画像が正しく読み込まれない

画像をブログ記事と同じディレクトリで管理しようと思っていました。  
そうすることでコンテンツの構成要素凝集され、見通しがよくなり記事を管理しやすくなるからです。

developmentモードではそのようなディレクトリ構成で問題なかったのですが、productionモードでビルドすると画像が正しく読み込まれなくなりました。

どうやらproductionモードでは画像ファイルを `public/` 配下に配置する必要がありそうで、やむなくそのようにしました。

##### やりたかった構成

```
/
┗ content/
    ┗ tech-blog/
        ┗ 2025-sample-post.md   # 記事ファイル
        ┗ 2025-sample-post/     # 記事に使う画像のディレクトリ
            ┗ sample-image.avif # 記事に使う画像ファイル
```

##### 仕方なくやった構成

```
/
┣ content/
┃  ┗ tech-blog/
┃      ┗ 2025-sample-post.md        # 記事ファイル
┃
┗ public/
    ┗ images/
        ┗ tech-blog/
            ┗ 2025-sample-post/     # 記事に使う画像のディレクトリ
                ┗ sample-image.avif # 記事に使う画像ファイル
```

#### 例: productionモードでビルドした時に、ページがリダイレクトされる

elm-pages は productionモードの場合のみ、 トレイリングスラッシュなしURLへのランディングを、トレイリングスラッシュ付きURLにリダイレクトします。

これは elm-sitemap の仕様と相性が非常に悪く、サイトのページを Google にインデックスさせなくします。
詳しくは次で述べます。

### 3. Google にインデックスされない問題に悩まされた

サイトのページたちを Google にインデックスさせるには、通常 sitemap.xml を Google Search Console に登録してページ一覧を読み込ませます。

しかし、Google Search Console が sitemap.xml にあるURLのページを読み込めないようで、せっかく作ったサイトが Google にインデックスされず困っていました。
インデックスには、「**リダイレクト エラー**」、「**ページにリダイレクトがあります**」などと表示されていました。

結論を言うと、原因は elm-pages と elm-sitemap の仕様が噛み合っていないことです。

#### [1] elm-pages の仕様

- elm-pages はプロダクションモードでビルドすると、トレイリングスラッシュなしURLへのランディングを、トレイリングスラッシュ付きURLにリダイレクトする (おそらく設定などで変更できない)

#### [2] elm-sitemap の仕様

- elm-sitemap は sitemap を作成する際に、URLのトレイリングスラッシュを強制で削除する

```elm
module Path exposing (join)


join : List String -> String
join urls =
    urls
        |> List.map dropBoth
        |> String.join "/"


dropBoth : String -> String
dropBoth url =
    url |> dropLeading |> dropTrailing


dropLeading : String -> String
dropLeading url =
    if String.startsWith "/" url then
        String.dropLeft 1 url

    else
        url


dropTrailing : String -> String
dropTrailing url =
    if String.endsWith "/" url then
        String.dropRight 1 url

    else
        url
```

[https://github.com/dillonkearns/elm-sitemap/blob/1.0.2/src/Path.elm](https://github.com/dillonkearns/elm-sitemap/blob/1.0.2/src/Path.elm)]

#### [3] Google Search Console の仕様

- リダイレクトがかかるURLはエラーとみなし、インデックスしない (それは当然のこと)
- リダイレクトがかかった場合、リダイレクト先のURLを取得しにはいかない（別サイトと想定されるので、それは当然のこと)
- トレイリングスラッシュがあるURLとないURLは別物とみなす(参考: [https://developers.google.com/search/blog/2010/04/to-slash-or-not-to-slash?hl=ja](https://developers.google.com/search/blog/2010/04/to-slash-or-not-to-slash?hl=ja))

#### [1]~[3] を踏まえ、つまりどうなるか

elm-sitemapで作成された sitemap.xml にあるURLは、全てトレイリングスラッシュがないURLです。elm-sitemapの仕様により強制的にそうなります。  
そのURLへ Google のボットがアクセスしようとします。

しかし elm-pages の仕様により、トレイリングスラッシュがないURLへのランディングはリダイレクトを発生させます。  
リダイレクトが発生することで、Google Search Console はそのURLをエラーとみなします。

よって、ページをGoogleにインデックスさせることが失敗に終わります。

#### どう対処したか

まずはライブラリの作者に仕様の欠陥を報告し、変更を求めました。
[https://github.com/dillonkearns/elm-sitemap/issues/6](https://github.com/dillonkearns/elm-sitemap/issues/6)

elm-pages と elm-sitemap の作者は同一人物だったので、状況の説明はしやすかったです。
彼は Google Search Console の仕様には詳しくないとのことで、仕様を示すドキュメントや、同様の問題に関する議論の事例が欲しいとのことでした。
十分なリファレンスを提示したのですが、その後音信不通になり、問題は放置されています。

仕方がないの自分で elm-sitemap を fork して、問題に対処できるように変更した Elm Package を作成・パブリッシュしました。 (これについてライセンス上の問題はありません。)

それが [hahnah/elm-sitemap](https://package.elm-lang.org/packages/hahnah/elm-sitemap/latest/) です。

元の dillonkearns/elm-sitemap 1.0.2 では、トレイリングスラッシュを問答無用で削除していましたが、hahnah/elm-sitemap では、渡されたURLのトレイリングスラッシュ有無をそのまま尊重するようにしています。

hahnah/elm-sitemap に切り替えることで、Google Search Console がページを参照できない問題は解決され、Google にインデックスされるようになりました。

## 最後に

よければ elm-pages-blog-template を使ってみてください。

[elm-pages-blog-template](https://github.com/hahnah/elm-pages-blog-template)
