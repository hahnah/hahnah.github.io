---
title: "肩こり解消のために無線分割キーボード Corne Chocolate を自作する〜①選定・準備編〜"
image: "/images/tech-blog/2023-build-corne-chocolate-1/corne-chocolate-build-kit-parts.avif"
description: "分割キーボードが肩こり解消に効果的だと聞き、どんなキーボードにしようかと考えて選び抜き、自作に必要なものを準備をしました。"
published: "2023-08-21"
updated: "2025-04-24"
category: "tech"
tags: ["keyboard", "self-made-keyboard", "corne"]
---

## 背景

最近慢性的な肩こりに悩まされています。切実です。  
整骨院で見てもらったところ、長時間のPC作業などがおそらく原因で巻き肩になってしまっているとのこと。  
巻き肩になるとどうしても肩が凝りやすくなるようです。  
ストレッチなどもしているのですが、継続は難しいです。

巻き型になってしまう原因を取り除くことで肩こりを解消できないかと思い、PC作業環境の見直しをしようと決めました。

Macbook搭載のキーボードを使っており、手を一箇所の狭い範囲に寄せることになるのでその時間ずっと巻き肩の姿勢になってしまいます。  
この肩こり原因を取り除くために分割型のキーボードを使うようにすればいいのではと考えたわけです。

## キーボード選び

### まず、筆者の基本情報とキーボードの好みについて

- 職業： Webエンジニア
- これまでのキーボード: 10年以上 MacBook搭載のJISキーボード または Magic Keyboard (JIS) を使ってきた

![MacBook JIS キーボード](/images/tech-blog/2023-build-corne-chocolate-1/macbook-keyboard.avif)

#### これまで使ってきた MacBook　JIS キーボードについて思うこと

- 省スペースで満足している。ただし、自分はファンクションキー系はほぼ使うことがないのでいっその事なくしてさらに小型化された方がいい。カーソル移動もEmacキーバインドのショートカットを使っているので、矢印キーもいらない。
- キーが低いのが気に入っている
- Macbookのキー配列に限ると、JIS配列が気に入っている
  - 英語と日本語を両方ともかなり入力するので、ステートレスに入力モード切り替えのできるように「英数」「かな」キーが独立してる点は脳内メモリへの負担が小さくて気に入っている
  - 「control」が「A」の左にある点が、Emacsキーバインド互換のショートカット入力をしやすくて気に入っている
  - JISとUSの配列では記号キーのマッピングが大きく異なるが、その点はどちらでもいいと思っている
- 親指の用途が「スペース」「英数」「かな」（あとせいぜい「command」）のキーを押すことしかなく、非合理的に思う。「shift」など、押しっぱなしにしつつ他のキーを入力するものについては親指で押すように設計されるべきと思っている。
- 見た目がスタイリッシュで気に入っている

### キーボードの選定基準

左右に分割されたキーボードであることは当然必須ですが、それ以外に好みもなるべく反映されたものであって欲しいです。

次のような条件をなるべく満たすことを基準としました。

#### 必須条件

- 左右分割型
- 60%以下のキーボード(Macbookよりも少ないキー数)
- ロープロファイル (ノートPCのようにキートップが低いタイプのこと)
- コードレス
- 親指を効率的に使える（Shiftキーなどの、他のキーと同時押しする系のキーは親指で押せれば、効率的なタイピングができるはず）
- 見た目が好みなこと (毎日のテンションが少し上がるので大事)
- 持ち運びしやすい(家と職場で同じものを持ち運んで使いたい)

#### 歓迎条件

- MacBookのJISキーボードのように、英数モードにするキーと、かなモードにするキーが独立している
- 「control」が「A」の左にある。もしくは親指でcontrol押せるのでも可
- 充電式

ちなみに、「英数モードにするキーと、かなモードにするキーが独立している」というのは、JIS配列であることが実質的な条件になってくる（キーマップをカスタマイズしない限りにおいて）。

### 分割キーボードの製品を探す

まずは既製品で自分の要件に合うものがないか探しました。

ほとんどの分割キーボードはハイプロファイルでその時点で選択肢はかなり限られました。  
また、ほぼ全ての分割キーボードはUS配列でJIS配列のものはほぼ見つかりません。  
分割キーボード自体のニーズがあまりないので、市場の小さなJIS配列のものがないのは仕方のないことです。

英字切り替えとかな切り替えのキーが別々になっていることが条件な時点で、ほぼJIS配列を求めていることになりますし、加えて、分割、ロープロファイル、見た目という条件を満たすものは当時見つかりませんでした。

ということで、自作キーボードを視野に入れ始めました。

### 自作キーボードの Corne Chocolate が目にとまった

[遊舎工房のサイト](https://shop.yushakobo.jp/collections/keyboard?sort_by=created-descending&filter.v.m.my_fields.keyboard_form=%E5%88%86%E5%89%B2%E3%82%AD%E3%83%BC%E3%83%9C%E3%83%BC%E3%83%89&filter.v.price.gte=&filter.v.price.lte=)で分割型の自作キーボードを探しました。

ここで見つけた [Corne Chocolate](https://shop.yushakobo.jp/products/corne-chocolate) が気に入りました。 (画像は Corne Chocolate リンク先より)

![Corne Chocolate サンプル](/images/tech-blog/2023-build-corne-chocolate-1/corne-chocolate-sample.avif)

検討してみたところ、頑張ってカスタムすれば全ての希望を満たせそうでした。  
初心者の私にカスタムできるかどうかという問題はありますが、技術的には可能ですw

| 要件                       | Corne Chocolate が満たすか | 補足                                                                                                                     |
| -------------------------- | -------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| 左右分割型                 | &#x2705;                   |
| 60%以下のキーボードサイズ  | &#x2705;                   | 30%キーボード(42キー)                                                                                                    |
| ロープロファイル           | &#x2705;                   |
| コードレス                 | カスタムすれば &#x2705;    | デフォルトは有線接続だが、BLE化用のパーツを別途使うことで対応可能                                                        |
| 親指を効率的に使える       | &#x2705;                   | 親指で押すキーが左右それぞれ３つずつある                                                                                 |
| 見た目が好み               | &#x2705;                   | 最高にクール！                                                                                                           |
| 持ち運びしやすい           | &#x2705;                   |
| 「英数」「かな」キーが独立 | カスタムすれば &#x2705;    | 自分でキーマップを決めるので、それ次第で実現可能                                                                         |
| 充電式                     | カスタムすれば &#x2705;    | 通常はコイン電池運用が想定されているが、カスタム次第では充電池でも可能。ただしやり方がよく分からなかったので一旦諦めた。 |

Corne Chocolate は42個しかキーがないので、JIS配列でもUS配列でもなく、少し変わった配列になる点は気がかりでした。  
しかし、考えるうちにそういう新しい体験も悪くないかなと思えてきたので、その点はトライしてみようとなりました。

というわけで、Corne Chocolate を自作することに決めました。

ちなみに私は自作キーボード未経験で、電子工作も学校の授業でしかやったことのない初心者です。ハンダ付けや電子回路のデバッグ？には苦手意識すらあります。  
しかし肩こり解消のためとあれば、やったるで！と意気込んでいました。

## 購入したキット・パーツ

自作キーボードを作るには、必要なパーツを買い揃えることになります。  
パーツを一つ一つ買い揃えることもできなくはないですが、自作キットが売られているのでそれを買うことにします。

キットには様々なパーツが含まれているのですが、個人の好みによるところの大きいパーツ（キースイッチとキーキャップ）については同梱されていないので、そちらは別途購入します。

また、キットの内容は有線接続を想定したパーツとなっています。今回は無線接続のキーボードとしたいので、それ用のパーツも追加で買います。

- [Corne Chocolate 自作キット](https://shop.yushakobo.jp/products/corne-chocolate)
- キースイッチ x42 ([Kailhロープロファイルスイッチ Red Pro](https://shop.yushakobo.jp/products/pg1350))
- キーキャップ 1U x40 ([MBK Choc Low-Profile Keycaps](https://shop.yushakobo.jp/products/mbk-choc-low-profile-keycaps))
- キーキャップ 1.5U x2 (1Uのキーキャップのサイズ違いバージョン)
- [BLE Micro Pro Type-C版](https://shop.yushakobo.jp/products/ble-micro-pro) x2 (無線化用のマイクロコントローラー)
- [BLE Micro Pro用電池基板](https://shop.yushakobo.jp/products/ble-micro-pro-battery-board) x2
- [コイン電池(CR1632)](https://www.amazon.co.jp/gp/product/B078S4PZ6Q) x2以上

合計で約3万円しました。

![Corne Chocolate 自作キット](/images/tech-blog/2023-build-corne-chocolate-1/corne-chocolate-build-kit.avif)

![Corne Chocolate 自作キットの中身](/images/tech-blog/2023-build-corne-chocolate-1/corne-chocolate-build-kit-parts.avif)

![Corne Chocolate 自作キット以外のパーツ](/images/tech-blog/2023-build-corne-chocolate-1/corne-chocolate-other-parts.avif)

また、これ以外にも次のパーツが必要になり、組み立て途中で追加購入しました。

- [黄銅スペーサー（丸）M2 15mm](https://shop.yushakobo.jp/products/a0800c2) (OLEDの上に被せるプレート用のスペーサー。キット付属のものだと長さが足りないので。必要な長さはパーツの取り付け方によって変わってくると思う。)
- 長めのピンヘッダ、ピンソケット (amazonで適当なのを買った。OLEDの設置箇所がキットの想定よりも高くなるので必要。)

### キースイッチには自分の好みに合うものをちゃんと選ぼう

前述のリストにある通り、キースイッチには Kailhロープロファイルスイッチ の Red Pro の軸のものを選びました。

このキースイッチは(というか大抵のキースイッチは)軸色で打鍵感の違いを表しているのですが、その種類によって打ち心地が異なります。

> 赤軸：スムーズなリニア軸  
> 茶軸：クリック感のあるタクタイル軸  
> 白軸：カチカチ感のあるクリッキー軸  
> Red Pro：軽くてスムーズなリニア軸  
> Pink：さらに軽くてスムーズなリニア軸  
> ([遊舎工房の商品ページ](https://shop.yushakobo.jp/products/pg1350)より)

キースイッチはキーボードを使っている時の感覚にかなり影響するので、自分に合うようにちゃんと選ぶのがいいと思います。  
私は遊舎工房の店舗に置かれていたキースイッチテスター（キースイッチの打鍵感をお試しできるもの）で確かめて、Red Pro が一番好みに感じたのでそれを選びました。

## 購入した道具類

以下の道具を買いました。

- [ハンダごて](https://www.amazon.co.jp/dp/B006MQD7M4)（温度調節機能のあるのものがおすすめ）
- [ハンダごてホルダー](https://www.amazon.co.jp/dp/B000TGNWCS)
- [作業マット</font>](https://www.amazon.co.jp/dp/B06XVJKS84)
- [ハンダ(精密プリント基板用)](https://www.amazon.co.jp/gp/product/B0029LGAMA)
- [ハンダ吸い取り線](https://www.amazon.co.jp/dp/B08DNGGMB2)　(ハンダをつけ間違えた、つけすぎたときに吸い取って取り除くために使う)
- [フラックス](https://www.amazon.co.jp/gp/product/B000TGJTUW)　(ハンダを着きやすくする液体。ハンダ付けが上手な人はいらないかも。)
- [ピンセット](https://www.amazon.co.jp/gp/product/B07BRSTLRQ) (普通のピンセットを買いましたが、たぶん**逆作用ピンセット**を買った方がいいです)
- [キープラー](https://www.amazon.co.jp/gp/product/B07CNRQJBD) (キーキャップを取り外したいときに使う。組み立てるだけなら不要だけど、メンテ用に購入。)
- [ニッパー](https://www.amazon.co.jp/gp/product/B000TGJSWG)
- [ラジオペンチ<](https://www.amazon.co.jp/gp/product/B001PR1N2G) (取り付けミスしたパーツを外すときに使う。実はミスした後に買った。)
- 精密ドライバー (元から持ってた。ちょうどいい大きさのプラスのものがあればOK)
- [絶縁テープ](https://www.amazon.co.jp/gp/product/B002G10NIK) (電池基板を安全に取り付けるには一応あった方がいい)
- 瞬間接着剤 (元から持ってた。電池基板をうまく取り付けるために使ったが、いらないかも。)

![自作キーボードのための道具](/images/tech-blog/2023-build-corne-chocolate-1/keyboard-build-tools.avif)

道具類には15,000円くらいかかってると思います(元から持っていたものを除く)。  
自分はamazonで買い揃えたのですが、遊舎工房で [工具セット](https://shop.yushakobo.jp/products/a9900to) としてまとめて購入することもできるので、そちらが楽だと思います。

## 準備完了

ここまでで、必要なパーツと道具の準備は完了です！  
次はいよいよ組み立てていきます。

初心者すぎる、かつ下調べもあまりしていない状態で組み立て始めたのでかなり苦労することになるのですが、よければ続きも読んでみてください。

[肩こり解消のために無線分割キーボード Corne Chocolate を自作する〜②作成失敗編〜](https://hahnah.github.io/tech-blog/2023-build-corne-chocolate-2/)

## おまけ情報

BLE化 Corne Chocolate ですが、今回は充電池対応を諦め、コイン電池を使うようにしています。  
できれば充電池に対応させたいのですが、どうやればできそうかの情報を残しておくことにします。

### BLE化 Corne Chocolate を充電池対応させるパーツ

充電池としてはリチウムイオンポリマー電池を使うことになるみたいです。  
市場にあるリチウムイオンポリマー電池の電圧は 3.7V のようなのですが、BLE Micro Pro のデザインガイドには

> バッテリー駆動する場合は1.7Vから3.6Vの電源が必要です。したがってLiPoバッテリーを使用する場合は別途レギュレータをつけて電圧を下げてください。

と記載があります。  
([https://github.com/sekigon-gonnoc/BLE-Micro-Pro/blob/master/docs/design_guide.md](https://github.com/sekigon-gonnoc/BLE-Micro-Pro/blob/master/docs/design_guide.md)　より)

つまり、リチウムイオンポリマー電池(3.7V)と、レギュレーター(電圧を下げるパーツ)を使うことになります。

Corne Chocolate に搭載できる大きさのリチウムイオンポリマー電池となると　110mA の容量のものが良さそうです（たぶん）。  
[これ](https://www.amazon.co.jp/dp/B074C2VHSY)なんかがそうですね。

また、レギューレーターは固定値電圧になるように電圧を下げてくれるようで、3.3Vにするものがよく売られていてそれが使えそうです。

...というところまでは調べられたのですが、レギュレーターをどう設置するのかがよく分からなかったので、私は一旦諦めてしまいました。  
でも答えまであと少しなので、気が向いたら再度調べて挑戦するかもしれません。

### 少し違う設計の Corne Chocolate のPCBを海外から入手することでも対応可能

実は海外から少し設計の違う Corne Chocolate パーツを買うこともできます。

例えば、[typeractive　というサイトでは BLEを前提とした版の Corne Chocolate のPCBを購入できます](https://typeractive.xyz/products/corne-partially-assembled-pcb)。

国内で販売されている Corne Chocolate のPCBとは異なる箇所があり、想定されているパーツも異なります。  
（PCBというのは、回路がプリント済みの電子基板のことです。）

得られる機能や用意されているアクセサリも若干異なってきます。違いは以下の通りです（他にもあるかも）。

|                                                  | 国内版                                                                                                                                                       | 海外版                                                                                                                                      |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------- |
| 有線接続 or 無線接続                             | 基本は有線接続。カスタマイズをすることで無線接続にもできる。                                                                                                 | 無線接続                                                                                                                                    |
| マイクロコントローラー                           | 基本となる有線接続用には Pro Micro。無線接続用には BLE MIcro Pro。                                                                                           | [nice!nano](https://typeractive.xyz/products/nice-nano)                                                                                     |
| OLEDモジュール(キーボード内蔵させるディスプレイ) | [これ(品名不明)](https://shop.yushakobo.jp/products/oled)                                                                                                    | [nice!view](https://typeractive.xyz/products/nice-view)                                                                                     |
| 電源供給方法                                     | 基本はPCに有線接続して電源供給する設計。カスタマイズをすることで、使い捨てのコイン電池で電源供給や、リチウムイオンポリマー電池(充電池)からの電源供給も可能。 | イオンポリマー電池からの電源供給                                                                                                            |
| 側面・底面が剥き出しにならないためのパーツ       | 底面にボトムプレートを取り付けるが、側面は剥き出しとなる                                                                                                     | 底面と側面を覆う [Corne Case](https://typeractive.xyz/products/corne-case) が売られており、それでカバーできる（国内版にも適合するかは不明） |

海外版の Corne Chocolate に挑戦してみるのもいいかもしれませんね。

**追記** マイコンのnice!nanoが2024年時点で技適を取得してないらしいので使えないですね &#x1f622;
