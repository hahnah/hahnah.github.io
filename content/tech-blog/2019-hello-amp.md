---
title: "AMP(Accelerated Mobile Pages)についての調査まとめ - 高速なモバイルWebページを可能にする技術"
image: "/images/tech-blog/2019-hello-amp/amp-surrounds.avif"
description: "今更ながら AMP というWeb高速化のための技術が気になり、調べたのでまとめる。"
published: "2019-05-01"
updated: "2025-06-22"
category: "tech"
tags: ["amp", "frontend", "performance"]
---

最近の自分の興味はモバイルWebの領域にあり、  
「そういえば昔何かのカンファレンスで聞きかじった AMP とかいうやつ (あんまり良くわかってない) を学んでみようかな」  
という気持ちになったので、ドキュメントを読み漁ったり、チュートリアルをいくつかやったり、カンファレンス([AMP Conf 2019](https://amp.dev/ja/events/amp-conf-2019))に参加したりした。

そこで知った AMPの概要と 個人的に気になったトピックスについて 情報をまとめておく。

## AMPとは何か

Accelerated Mobile Pages。 略して AMP。  
Webページを高速に表示するための技術(フレームワーク)である。

現代ではスマートフォンを使い低速なネットワーク環境下でWebページを見ることが多いが、AMPを使ったWebページはそのような状況下でも高速に表示される。

AMPはGoogleが中心となって開発しており、2015年10月よりOSS化されている。

## AMPを使うと何が嬉しいのか

言い換えると、Webページが高速だと何が嬉しいのか。

### 1. ユーザーが ストレスフリーで快適なWebを体験できる

Webページが高速に表示され高速に動作するほど、もちろんWeb体験は快適なものとなる。

逆にWebページのパフォーマンスが悪いと、ユーザーはストレスを感じるだろう:

- Webページの表示が遅いくてイライラする
- ローディングのぐるぐるで長時間待たされてイライラする
- 時間が経ってから画像や広告が表示され、それまで読んでいた文章の表示位置がズレてイライラする

### 2. サイトの収益や アクセス数の増加が期待できる

ユーザーが前述のようなストレスを感じてしまうと、閲覧を諦めてサイトから離脱してしまうだろう。  
参考値として、モバイル端末でページの表示に3秒以上かかると 53%のユーザーは離脱してしまうらしい  
([Find out how you stack up to new industry benchmarks for mobile page speed --- Think with Google](https://www.thinkwithgoogle.com/marketing-resources/data-measurement/mobile-page-speed-new-industry-benchmarks/))。

AMP Conf 2019 で発表された導入事例を１つ紹介する。  
[ETtoday 新聞雲](https://www.ettoday.net/)という台湾の大手ニュースサイトでは、AMPを導入して最適化を行ったことで次の成果が出ている:

- 表示速度が4倍 (4倍になった結果何秒なのかわからないが)
- 広告収益が9.6倍

APM Conf 2019 内での紹介パートは以下のYouTubeリンクから見れる  
[https://www.youtube.com/embed/Q6BmFx7ivNg?start=1958&end=2030](https://www.youtube.com/embed/Q6BmFx7ivNg?start=1958&end=2030)

### 3. Webを活用したグローバルなビジネス展開に役立つ

グローバルをターゲットにしたWebページでは、特に高速化の恩恵があるだろう。  
冒頭で `現代ではスマートフォンを使い低速なネットワーク環境下でWebページを見ることが多い` と述べたが、  
特に東南アジア、インド、アフリカ、中国、南米などでこの傾向が顕著だと言われている。

### (参考情報として) AMPの導入事例集が公開されている:

[Success stories --- AMP公式サイト](https://amp.dev/ja/success-stories/)

## こんにちは AMP

Hello World 的な簡易なAMPページをつくった。  
[こちらのリンクで見れる。](https://hahnah.github.io/til-amp/hello-amp/)

ページの中身はこれだけ:

- 文字の表示
- 画像の表示
- YouTubeの埋め込み

このAMPページがどんなHTMLドキュメントで出来ているのか、見てみる。

```html
<!doctype html>
<html amp lang="en">
  <head>
    <meta charset="utf-8" />
    <script async src="https://cdn.ampproject.org/v0.js"></script>
    <script
      async
      custom-element="amp-youtube"
      src="https://cdn.ampproject.org/v0/amp-youtube-0.1.js"
    ></script>
    <title>Hello, AMP</title>
    <link
      rel="canonical"
      href="http://example.ampproject.org/article-metadata.html"
    />
    <meta
      name="viewport"
      content="width=device-width,minimum-scale=1,initial-scale=1"
    />
    <script type="application/ld+json">
      {
        "@context": "http://schema.org",
        "@type": "NewsArticle",
        "headline": "Open-source framework for publishing content",
        "datePublished": "2019-04-30T00:00:00+09:00"
      }
    </script>
    <style amp-boilerplate>
      body {
        -webkit-animation: -amp-start 8s steps(1, end) 0s 1 normal both;
        -moz-animation: -amp-start 8s steps(1, end) 0s 1 normal both;
        -ms-animation: -amp-start 8s steps(1, end) 0s 1 normal both;
        animation: -amp-start 8s steps(1, end) 0s 1 normal both;
      }
      @-webkit-keyframes -amp-start {
        from {
          visibility: hidden;
        }
        to {
          visibility: visible;
        }
      }
      @-moz-keyframes -amp-start {
        from {
          visibility: hidden;
        }
        to {
          visibility: visible;
        }
      }
      @-ms-keyframes -amp-start {
        from {
          visibility: hidden;
        }
        to {
          visibility: visible;
        }
      }
      @-o-keyframes -amp-start {
        from {
          visibility: hidden;
        }
        to {
          visibility: visible;
        }
      }
      @keyframes -amp-start {
        from {
          visibility: hidden;
        }
        to {
          visibility: visible;
        }
      }
    </style>
    <noscript
      ><style amp-boilerplate>
        body {
          -webkit-animation: none;
          -moz-animation: none;
          -ms-animation: none;
          animation: none;
        }
      </style></noscript
    >
    <style amp-custom>
      body {
        background-color: white;
      }
      amp-img {
        background-color: gray;
        border: 1px solid black;
      }
    </style>
  </head>
  <body>
    <h1>Welcome to the mobile web</h1>
    <amp-img
      src="hello-amp.jpg"
      alt="hello"
      height="720"
      width="1280"
      layout="responsive"
    ></amp-img>
    <amp-youtube
      width="480"
      height="270"
      layout="responsive"
      data-videoid="lBTCB7yLs8Y"
    >
    </amp-youtube>
  </body>
</html>
```

普通のHTMLのようで少し違う。

AMPを使ったHTMLドキュメントは、次を満たす必要がある ([AMP HTML ページを作成する --- AMP公式サイト](https://amp.dev/ja/documentation/guides-and-tutorials/start/create/basic_markup)より抜粋して列挙):

- (2行目) 最上位階層のタグを`<html`&#x26a1;`>`にする (`<html amp>`も可)。
- (4行目) `<meta charset="utf-8">`タグを`<head>`タグの最初の子要素にする。
- (5行目) `<script async src="https://cdn.ampproject.org/v0.js"></script>`タグを`<head>`タグの 2 番目の子要素にする。
- (8行目) `<head>`タグ内に`<link rel="canonical" href="$SOME_URL">`タグを含める。
- (9行目) `<head>`タグ内に`<meta name="viewport" content="width=device-width,minimum-scale=1">`タグを含める。`initial-scale=1` を含めることも推奨されます。
- (18行目) `<head>`タグ内に [AMP ボイラープレート コード](https://amp.dev/ja/documentation/guides-and-tutorials/learn/spec/amp-boilerplate)を含める。

それともう一つ、主だったものとして CSSについての制約がある ([体裁とレイアウトを変更する --- AMP 公式サイト](https://amp.dev/ja/documentation/guides-and-tutorials/start/create/presentation_layout)):

- (19行目) CSS は `<head>`内のインラインCSS`<style amp-custom>`でのみ記述可能 。
  - 外部CSSファイルや `<head>`外のインラインCSS などは利用できない。

また、`<amp-img>`や`<amp-youtube>`いった、見慣れないタグが使われていることにも気づいただろうか (これについてはすぐ後に述べる)。

## AMPを構成する3要素

`AMP HTML`, `AMP JS`, `AMP Cache`の３つだ。

### 1. AMP HTML

上でAMPページのHTMLドキュメント例を見せたが、このようなHTMLを`AMP HTML`という。  
つまり、AMP HTMLとは前述に列挙した条件を満たすようなHTMLのこと。

AMPを使ったWebページにおいては一部のHTMLタグは利用不可であり、代わりにAMPが提供する高速で安全性の高いカスタムタグ(AMPコンポーネント)を用いる。  
例えば `<img>`は利用不可であり、代わりに`<amp-img>`を用いる。  
`<div>`や`<p>`なんかは普通に使える。  
(HTLMタグの代替や制約については [AMP HTML Specification > HTML Tags --- AMP 公式サイト](https://amp.dev/ja/documentation/guides-and-tutorials/learn/spec/amphtml) を参照。その他のAMP HTML全般の仕様についても詳しく載っている。)

ちなみにだが、通常(非AMPという意味)のWebページにおいてAMPコンポーネントを使うことは今のところ出来ない(非AMPページで`amp-img`等は使えない)。  
またしかし、それを実現する Bento AMP という機能追加が進行中の模様 (詳細は **Web Components としての AMPコンポーネント** に後述)。

### 2. AMP JS

AMP JS は、 AMP HTML のドキュメントを動作させるための JavaScript ライブラリのこと。  
「こんにちは AMP」の例でいうと、次のコードにより読み込まれる JavaScript がそれにあたる。

AMPを使うために必須な AMP JS の読み込み (5行目):

```html
<script async src="https://cdn.ampproject.org/v0.js"></script>
```

AMPページにYouTube動画を埋め込むための、`amp-youtube`という AMPコンポーネント を使うのに必要な AMP JS の読み込み (6行目):

```html
<script
  async
  custom-element="amp-youtube"
  src="https://cdn.ampproject.org/v0/amp-youtube-0.1.js"
></script>
```

ちなみに、 「こんにちは AMP」 にて示したAMP HTMLのドキュメント例では、`amp-youtube`を使うためにAMP JSの読み込みを記述しているが、`amp-img`については特に書いていない。  
これは、 Built-in か Extended かの違いによるもの。  
`amp-img`は Built-in コンポーネント なので必須の AMP JS を読み込めば利用できるが、  
`amp-youtube`は Extended コンポーネント なので、個別に`amp-youtube`用の AMP JS が必要になる。  
(AMPコンポーネントにはこれら２種類のほかに、Experimental コンポーネントという試験版のものもある)

AMPチームが高速化や安全性を担保した JavaScript のみが AMP JS として提供されているので、AMPを使っていれば(ほぼ)必然的に高速なWebページに仕上がるように出来ている。

ところで、AMP JS ではなくサードパーティの JavaScript や、自分で独自に記述した JavaScript を使いたい場合はどうすればいいのだろうか？  
実は AMP JS 以外の JavaScript は基本的には利用不可だ。  
ただし全く利用出来ないわけではなく、方法はある (詳細は **AMPとJavaScript** に後述)。

### 3. AMP Cache

AMPはキャッシュの仕組み(CDN)を提供しており、これを AMP Cache と呼ぶ。

AMP Cache により、AMPページは効率的かつ安全にプリリロードされるようになる。  
また、コンテンツに対してパフォーマンス最適化を行ったり、定められた条件を満たすAMPページだけを配信したりといったこともしている。

## AMPはなぜ速いのか

すごく大雑把に書くと、次のことで高速化を実現している (というか、遅くならないようにしている):

- メインページの実行を邪魔させない
- ページのレイアウト認識やレンダリングを早期に行えるようにする
- レイアウトの再計算を削減する
- リソース読み込みを工夫する
- CPUだけでなくGPUも使う

もう少し詳細には次の7つ ([How AMP works --- AMP公式サイト](https://amp.dev/ja/about/how-amp-works)):

1. **サードパーティのJavaScriptを全てクリティカルパスの外に置く(iframeのサンドボックス内に制限する)**

- メインページの実行をサードパーティの同期的なJavaScriptの読み込みがブロックすることを防ぐため

2. **CSSのインライン化とサイズ制限**

- CSSが外部ファイルで定義されている場合に発生する追加のHTTPリクエストが メインページの処理を遅延させてしまうことを防ぐため
- インラインCSSのサイズは50KiBまでに制限される

3. **Webフォントのダウンロードを効率的に行う**

- Webフォントはデータサイズが巨大なため、WebフォントのダウンロードはWebサイトのパフォーマンスにとって決定的な要因となる。前述の非同期JavaScriptやインラインCSSといった制約が存在するのは、Webフォントのダウンロード開始を他のHTTPリクエストに邪魔させないためでもある。

4. **スタイルの再計算をできるだけ行わない**

- スタイルの再計算が起こるとブラウザはWebページ全体を再レイアウトしなければならず、これがFPSを下げる要因となる
- AMPでは全てのDOMを読み込んだ後で描画処理を開始するようになっており、これによって１フレームで最大１回のスタイル再計算しか起こらない

5. **CSSアニメーションはGPUアクセラレーションの効いたもののみを動作させる**

- アニメーションをGPUで高速に処理するため。また、CPUリソースをアニメーション処理に使わずに済むので、その分他の処理をCPUにさせられるようになる。
- CSSアニメーションにおいてAMPでは、コンポジターが処理できるプロパティである`transform`(形状) と `opacity`(不透明度) の変更のみが可能である。この制約によりレンダリングパイプラインにおける レイアウト と ペイント が不要になるので、処理の重いアニメーションを抑制できる。
  この辺りをより詳細に知りたい場合は以下に目を通すと良さそう:
  - [レンダリングパフォーマンス --- Web Fundamentals](https://developers.google.com/web/fundamentals/performance/rendering/?hl=ja)
  - [コンポジタ専用プロパティの優先使用、およびレイヤー数の管理 --- Web Fundamentals](https://developers.google.com/web/fundamentals/performance/rendering/stick-to-compositor-only-properties-and-manage-layer-count)

6. **リソース読み込みの優先順位づけ**

- AMPはリソースのダウンロードをコントロールしており、優先順位づけをし、また必要なリソースのみを読み込むようになっている。
  リソースが必要になるまで可能な限り読み込みを遅らせ、かつ、lazy-load するリソースは可能な限り早期に事前読み込みする。

7. **瞬時にページを読み込む**

- AMPは [preconnect API](https://www.w3.org/TR/resource-hints/#dfn-preconnect) を利用することでHTTPリクエストを最大限高速化している。これにより、ユーザーがWebページを開くより前にレンダリングすることができる。

## 個人的に気になるトピックス

２つ: `AMPとJavaScript`,`Web Components としての AMPコンポーネント`.

### AMPとJavaScript

AMPページでは基本的に AMP JS の JavaScript しか許されない。

しかし残念ながら、 インタラクティブな機能を作りたい場合は AMP JS だけでは実現できない場合もあるだろう。  
例えばECサイトにおいては、買い物のためにユーザー情報を扱うが、そのための JavaScript が別で必要になってくる。

"基本的には" AMP JS しか許されないのだが、自分で書いた JavaScript や サードパーティの JavaScript を扱う方法が一応存在する。

( ちなみに、ちょっとしたインタラクティブなものであれば JavaScriptを使わずとも [amp-bind](https://amp.dev/ja/documentation/components/amp-bind)で作れるかもしれない。  
amp-bind を使ったチュートリアル: [インタラクティブな AMP ページを作成する --- AMP公式サイト](https://amp.dev/ja/documentation/guides-and-tutorials/develop/interactivity/) )

#### 方法その1: amp-iframe

[amp-iframe](https://amp.dev/ja/documentation/components/amp-iframe) は AMP用の iframe。

AMPのチュートリアルページ([検証エラーを解決する \> サードパーティの JavaScript を除外する --- AMP 公式サイト](https://amp.dev/ja/documentation/guides-and-tutorials/start/converting/resolving-errors.html#%E3%82%B5%E3%83%BC%E3%83%89%E3%83%91%E3%83%BC%E3%83%86%E3%82%A3%E3%81%AE-javascript-%E3%82%92%E9%99%A4%E5%A4%96%E3%81%99%E3%82%8B))にも書かれているが、あまり推奨はされておらず苦肉の策という感じ。

> iframe に JavaScript を含める方法は、最後の手段と考えてください。可能な限り、AMP コンポーネントを使用して JavaScript の機能を置き換えてください

ただ、最後の手段など言っている明確な理由は調べてみてもよくわからなかった。  
amp-iframe 内のページはメインページとは別にレンダリングの処理やHTTPSリクエストが実行されるが、サンドボックス内で安全に非同期で実行され、メインページの実行をブロックすることはない。例え`document.write()`など非常に重たい処理が含まれていたとしても問題ないとのこと。

最後の手段などとしている理由は、amp-iframe 内のページの高速化までは面倒見きれないから ということだろうか？

#### 方法その2: amp-script

この記事を書いている時点ではまだ試験版なのだが、[amp-script](https://amp.dev/ja/documentation/components/amp-script) を使う手もある。

amp-script は 任意のJavaScriptをWebWorkerで実行する。  
メインスレッド外で実行するので、メインページの実行をブロックすることはない。

大まかな仕組みとしては、

> 本来ならDOMが存在しないWebWorkerだが、しかしDOMに触れないわけではない。 WebWorker の中に DOM と似たようなオブジェクトが実装されており、それを操作することでメインスレッドのJSに反映される。
> ([AMP で任意の JS を実行できる amp-script を試してみた --- Qiita](https://qiita.com/mizchi/items/c7d648eafb03d4c5378a))

ということらしい。

amp-script が扱える JavaScript には、**150KiB まで** というサイズ制限がある。  
1つのamp-scriptコンポーネントにつき、圧縮前のサイズで150KiBまで。  
これは、ローエンドデバイスでのAMPページの性能影響を考慮しての上限とのこと。

このサイズ制限が結構キツイかもしれない。

> サイズ制限のせいで、いわゆる JS フレームワーク は preact(7kb) か lit-html(3kb) ぐらいしか選択肢にならない。もしかしたら svelte とか使えるかもしれないが…
> ([amp-script の実用性について考える --- mizchi's blog](https://mizchi.hatenablog.com/entry/2019/04/19/124652))

#### どれを使えばいいのか

AMPページにインタラクティブな機能を組み込みたいなら、

まずは`AMP JS`での実現を検討し、  
だめならば`amp-script`の利用を検討し、  
それでもだめならば`amp-iframe`を使う

というのが基本的な考え方だと思う。

### Web Components としての AMPコンポーネント

AMP関連で個人的に今一番気になっているのが、`Bento AMP`というやつ。  
Bento AMPは、非AMPのWebページにおいても AMPコンポーネントを利用可能にするものである。  
2019年4月のカンファレンスで発表されたが、まだ開発が始まったばかりで情報もほとんど公開されていない。

&darr; AMP Conf 2019内での Bento AMP 発表 (２分間のみ)  
[https://www.youtube.com/embed/W7T5tMgrrFs?list=PLXTOW_XMsIDSY0USlzgoaIkRyPcHklrEl&start=30505&end=30625](https://www.youtube.com/embed/W7T5tMgrrFs?list=PLXTOW_XMsIDSY0USlzgoaIkRyPcHklrEl&start=30505&end=30625)

Bento AMP が実現すると、AMPコンポーネント は通常の Web Component と同じような使い方ができるようになる。

自分はAMPコンポーネントの以下の点に魅力を感じている:

- 高速性
- 安全性
- レスポンシブ化が容易 ([レイアウトとメディアクエリ --- AMP 公式サイト](https://amp.dev/ja/documentation/guides-and-tutorials/develop/style_and_layout/control_layout))
- 普通に便利なUIコンポーネントが揃っている
- 特に [amp-story](https://amp.dev/ja/documentation/components/amp-story) など見栄えが非常に良い.

しかし正直なところ、Webページ全体をAMP化するのはちょっと…とも思っている。  
なぜかというと、AMPの制約に従うと、例えばReactなど好みのレンダリングフレームワークで開発できなくなってしまのが大抵だろう (Reactはあくまで例として)。  
AMPの強みであるUXはもちろん重要なのだが、DXだって大事にしたい。  
そこで、Bento AMP があれば いいとこ取りが出来ちゃうのではないかと期待している。

それと、動的な要素の多いWebアプリを作る場合には AMP JS以外の JavaScript がたくさん必要になってくるが、それだとAMPをメインのフレームワークとして使うのは辛いと思っているので、やはりAMPをフレームワークとしてではなく パーツとして使う道は欲しい。  
なので Bento AMP にはこれまた期待。

そして、ゆくゆくは Bento AMP のコンポーネントたちが Web Components のベストプラクティス集という立ち位置になるんじゃないかなぁと想像している。

また、Bento AMP は既存のWebサイトに対する AMPの段階的な導入も可能にするだろう。  
(むしろこっちがAMPチームの狙い)

Bento AMP については現時点でほとんど情報がないが、おそらく次のissueで開発が進められているのでウォッチしたいところ。

- [[MASTER FEATURE] Enable use of AMP Components outside of AMP pages](https://github.com/ampproject/amphtml/issues/20456)

## AMPについて色々調べてみての所感

パフォーマンスを意識しながらリッチでレスポンシブなWebページを作成するのはかなりの知識を要するだろうし、自力では苦労するだろうというのは容易に想像できる。  
AMP はそんな非力な自分でもそれを可能にする技術だと思うし、使えるシーンでは積極的に使いっていきたい。

ただし、AMPに頼れないシーンも多々出てくると思う。  
自分が業務で開発に携わるWebといえば 動的な要素が強いWebアプリばかりであるし、正直に言ってそこでAMPは使えそうにないし、無理やり使ってもあまりいいことはなさそう (今すぐに業務で使いたいというモチベーションではないので、別にいいのだけど)。  
そもそもAMPは静的ページを適用範囲としてきたようだ。とは言ったものの、最近では動的ページの領域にも食い込めるような進化を始めているし (amp-bind, amp-script など)、将来的には変わるかも知れない。

個人的に今後のAMPに最も期待することは、やはり &#x1f371; Bento AMP である。  
非AMPのWebページでも利用できて、高パフォーマンスで、容易にレスポンシブ対応できるような、Web Components のベストプラクティス集が欲しい。

それと、AMPについて調べるうちにWebのパフォーマンスに影響する要因についても少し知れたので、その知識は非AMPにおいても役立ちそうだ。  
今後パフォーマンスで行き詰まったら、「AMPではどうしてるのか？」という風に参考にするかもしれない。

## AMP入門に役立つチュートリアルたち

- [初めての AMP ページを作成する --- AMP公式サイト](https://amp.dev/ja/documentation/guides-and-tutorials/start/create/index.html): AMPに こんにちは するチュートリアル
- [Build websites with AMP! --- AMP公式サイト](https://amp.dev/ja/documentation/guides-and-tutorials/): こんにちは の次にやる色んなチュートリアルたち

## AMPでの開発に役立つリファレンスたち

- [The AMP component catalogue --- AMP公式サイト](https://amp.dev/ja/documentation/components/): AMPコンポーネントの一覧
- [Learn AMP by example --- AMP公式サイト](https://amp.dev/ja/documentation/examples/): AMP利用のコード例とデモの一覧
- [Easily build user first websites with our templates --- AMP公式サイト](https://amp.dev/ja/documentation/templates/): AMPで作るWebサイトのテンプレート一覧

## 参考文献

主にAMPの概要調査で参考にした文献たち (記事本文中にリンクを置いてないものだけ):

- [AMPで加速するモバイルウェブアプリケーション](https://docs.google.com/presentation/d/1ZYyHFRMZnD6bfi6fl9yh9G_TIs3roSxvp-Goa1JZv_c/htmlpresent)
- [AMPの気になること全部、Googleの山口さんに聞いてきました！ --- HTML5 Experts.jp](https://html5experts.jp/shumpei-shiraishi/24795/)
- [検証エラーを解決する > AMP のレイアウト システム --- AMP公式サイト](https://amp.dev/ja/documentation/guides-and-tutorials/start/converting/resolving-errors.html)
