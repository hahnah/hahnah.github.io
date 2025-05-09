---
title: "分割キーボード Corne Chocolate を1年間使ってみてどうだったか"
image: "/images/tech-blog/2024-one-year-review-of-corne-chocolate/using-corne-chocolate.avif"
description: "分割キーボードの Corne Chocolate を使い始めてから1年と少しが経ったので長期レビューをする。"
published: "2024-07-18"
updated: "2025-04-10"
category: "tech"
tags: ["keyboard", "self-made-keyboard", "corne"]
---

## Corne Chocolate とは

![Corne Chocolate](/images/tech-blog/2024-one-year-review-of-corne-chocolate/my-corne-chocolate.avif)

左右分割型のロープロファイルキーボード。

Corne Cherry というキーボードが元々あるのだが、それの「Choc」(背が低い)版ということで Corne Chocolate というらしい。

自分が使っているのはバージョン2だが、今はバージョン4が出ている。  
(ちなみにバージョン3はCherryの方しか存在ない)

- [Corne Chocolate v2](https://shop.yushakobo.jp/products/corne-chocolate)
- [Corne v4 Chocolate](https://shop.yushakobo.jp/products/8962)

## 使い始めた理由

詳しくは以前の記事を見てもらいたいのだが、  
肩こりに悩まされていてそれの解消のために Corne Chocolate を使い始めた。

[肩こり解消のために無線分割キーボード Corne Chocolate を自作する〜①選定・準備編〜](https://hahnah.github.io/tech-blog/2023-build-corne-chocolate-1/)

通常のキーボードを使う際には肩を中央にすくめるような感じになってしまい、これが巻き肩を引き起こし慢性的な肩こり症状が出てしまう。

分割キーボードは肩を開いた状態で使うので、肩こりの解消につながるというわけだ。  
(ちなみに分割キーボードのように人間工学に基づいてデザインされたキーボード全般を「エルゴノミクスキーボード」と言ったりもする)

そのジャンルの中で自分の好みのものを探していたところ Corne Chocolate を知り、使い始めた。

## 現状の構成・設定

### ハードウェア構成

キーボード: Corne Chocolate v2  
マイクロコントローラー: BLE Micro Pro  
キースイッチ: Sunset Tactile Choc Switches  
キーキャップ: MBK Choc Low-Profile Keycaps  
テンティングレッグ: Bobtail Keyboard Tenting Legs for Split Keyboards

#### マイクロコントローラーと電源について

無線接続で使いたかったのでBLEに対応しているマイコンを使っている。  
電源供給はコイン電池だ。

#### キースイッチについて

使い始めた当初は Kailh Choc V1 Red Pro という、リニアのキースイッチを使っていた。  
しかしカラムスタッガードという慣れないキー配列では、軽く触れるだけで反応してしまうリニアキースイッチはミスタイプをかなり引き起こしていた。

そこでタクタイルキースイッチの Sunset Tactile Choc Switches に変えたところかなり安定するようになったのと、打鍵感も気に入ったのでこれを使い続けている。

![キースイッチ](/images/tech-blog/2024-one-year-review-of-corne-chocolate/key-switches.avif)

画像の左にあるのが Kailh Choc V1 Red Pro で、右にあるのが Sunset Tactile Choc Switches。

### BLE Micro Pro の設定について

左右がBLEで無線接続しているため、左右間の入力遅延が発生する問題に悩まされていた。  
たとえば素早く「key」とタイプした際に、「eky」という入力になってしまう。

これはかなりストレスだったので BLE Micro Pro の Connection Interval の設定値を最小にした。  
電池の消耗は激しくなるが、入力遅延の問題はほとんど気にならなくなった。

### テンティングレッグについて

自分は手をなるべく浮かせずに楽にタイピングしたいのもあってロープロファイル派だ。Corne Chocolate ももちろんロープロファイルだ。

けれども実は Corne Chocolate でも、少し手を浮かさないと打てないシーンがある。小指のキーを打つ時がそうだ。  
この問題は手とキーボードの角度も関係しているので、あくまで自分にとっての楽な使い方ではそうなる、という話。

キーボードをテンティングさせるとこの問題は少しマシになる。  
小指球をデスクに置いて自然に手を固定できるようになるので、かなり打ちやすくなる。

けれどそれでも、小指のキーの上の方(PとかQとか)を打つには、手を少し浮かせる時がまだある。

![テンティングレッグ](/images/tech-blog/2024-one-year-review-of-corne-chocolate/tenting-legs.avif)

![テンティングして打つ](/images/tech-blog/2024-one-year-review-of-corne-chocolate/using-with-high-tenting-2.avif)

ちなみにこのテンティングレッグは伸ばすと机の上で滑ってしまうので、画像のようにラバーコースターの上で使っている。  
脚を折り畳んだ状態なら滑り止めがついているのでそのままでも使える。  
折り畳んでいても多少角度がつくので、伸ばすか畳むかは好み。

![ラバーコースターの上でテンティングして使う](/images/tech-blog/2024-one-year-review-of-corne-chocolate/tented-corne-chocolate-on-rubber-coaster.avif)

### キーマップ

今のキーマップはこれ。  
自分の利用範囲(日本語文章入力、英語文章入力、プログラミング)において使いやすくなるよう考えた。

**レイヤー0**
![キーマップレイヤー0](/images/tech-blog/2024-one-year-review-of-corne-chocolate/keymap-layer0.avif)

**レイヤー1**
![キーマップレイヤー1](/images/tech-blog/2024-one-year-review-of-corne-chocolate/keymap-layer1.avif)

#### このキーマップの良い点

- US配列がベースになっていて、収まらないキーは本来の場所の近くに置いていたり、類似記号のキーをレイヤー0とレイヤー1の同じ場所に配置しているので覚えやすい
- モディファイアキーの類はなるべく親指に配置することで、同時押し入力が合理的に行えるようになっている
- 右手親指で MO1キーを押しながら H, J, K, L キーで矢印キーを入力できるので、vimのカーソル操作と同じ感覚で操作できる。しかも片手でできる。
- 英数、かなの切り替えキーが個別にある

#### キーマップの改善した方がいい点

- 使用頻度の低い Alt キーは親指じゃなくて小指の場所に配置した方がいいかもしれない。逆に使用頻度の高い Ctrl キーは親指の場所に配置した方が合理的。これは当初から気づいていたけれど、A キーの左隣に Ctrl キーがあるキーボードに慣れていたのでそのままにしていた。変えたい気持ちが時々現れる。
- レイヤー1の「AD WO L」(新しいデバイスとのペアリング開始)、「ADV ID0」(ID:0のデバイスと接続)、「ADV ID1」、「ADV ID2」を間違って押してしまって、キーボードとPCの接続が切れることがよくある。これは例えば、「6c」と入力した際に起こることがある。「6」を打つために MO1 キーを押してレイヤー1にするのだが、その後 MO1 を離した判定になるよりも先に 「c」 を押すと、レイヤー1の「ADV ID1」が入力されてしまうのだ。これを解決するにはレイヤー2を導入する必要があると思うのだが、そのためにはどこかに MO2 のキーを配置しなければならないので保留している。

## 使ってみて良かった点、気に入っている点

- 期待通り肩こりしなくなった。使い始めて3,4ヶ月くらいからだと思うが、肩こりしなくなっていた。
- 見た目がかわいい
- コンパクト。持ち運びしやすい
- 親指を効率的に使えるのは想像通りかなり良かった
- 数字や記号のタイプミスが減った
- このキーボードを使う時間が楽しくなった(特に始めのうちはそう)

## 当初心配していたが案外問題なかった点

- **キー数の少なさ:** 少ないキーでも全然やれている。むしろキーが少なく、ホームポジションからあまり動かさないで済むので、楽な上に慣れれば普通のキーボードよりもミスタイプは少ない。
- **電池持ち:** 2-3ヶ月に1度くらい電池交換している気がするが、そんなに億劫ではない
- **カラムスタッガード配列への慣れ:** 使い始めのうちはかなりミスタイプしていて、これがキーボード移行時の最大の壁だった。けれど慣れればむしろカラムスタッガードの方が使いやすい。ロウスタッガードは非合理的ですな。
- **耐久性:** 今の所壊れてはない。強いて言えば、一度ネジが緩くなってたくらい。
- **自分でメンテナンスできるかどうか:** 故障してないのでまだなんとも言えない。けれど自分で修理もやれると思っている。たまにキーキャップを外して掃除くらいはしている。
- **ロープロファイルなんだけれど、大して低くない:** メカニカルスイッチなので、これまで使ってきたノートPCのキーボードほど低くはない。けれどもう慣れて全然気にならなくなった。

## 不満な点

- 前述した通り小指のキーが一部押しづらい。小指のカラムはもう少し下にズレていた方がいい。
- ロープロファイルであり自分はケースなしの裸で使ってもいるので、たぶん打鍵音が良くない。(そもそも打鍵音の良いキーボードを使ったことはないが、YouTubeとかで見る打鍵音が好評のキーボードはかなり心地いい感じに聞こえる。)
- 接続の安定性が低い
  - コイン電池が少し消耗すると接続の安定性が落ちる気がする
  - PC &#x2194;︎ マスター側キーボード &#x2194;︎ スレーブ側キーボード の間で接続があるのだが、全てが一発で接続されることはあまりない。
- 接続先デバイスの切り替えにはキーを押すだけなのだけれど、うまく切り替わりづらい
- ごく稀にマイクロコントローラーの設定が吹っ飛んで初期化される

## 総評

利用し始めた時の期待は概ね満たされていて、細かな不満点はあるが全体として非常に良い。  
肩こりに悩んでいる人は Corne Chocolate のような左右分割型のキーボードを絶対に使うべき。

見た目の良さとコンパクトさを兼ね備えている点も良い。コンパクトなので、持ち運んで自宅と職場の両方で使える。  
指を無理に伸ばしたり、手を浮かせて動かしたりすることが少なく済むので、楽に、タイプミス少なく長時間使える点も良い。

有線接続でも良いのなら、最新バージョンの Corne v4 Chocolate / Corne v4 Cherry がお勧めできる。  
(v4はマイコンが基盤に直接実装されている関係で、無線接続にカスタマイズすることができない)

## 理想のキーボードを求めて

不満な点を解消した理想のキーボードにたどり着くには、キーボードの設計から自分自身でやるしかなさそうだ。

特に、以下の欲求が強い:

- 手を全く浮かせずとも打ちやすいキー配列にしたい
- 打鍵音を良くしたい
- 接続の安定性を高めたい

そんなわけで近々、完全オリジナルのキーボード設計に挑戦したい。
