---
title: "肩こり解消のために無線分割キーボード Corne Chocolate を自作する〜②作成失敗編〜"
image: "/images/tech-blog/2023-build-corne-chocolate-2/set-right-ble-micro-pro.avif"
description: "無線化 Corne Chocolate の自作に挑戦した記録。結果的には失敗しましたが何かの役に立つかもしれないのでビルドログを残します。"
published: "2023-09-25"
updated: "2025-04-20"
category: "tech"
tags: ["keyboard", "self-made-keyboard", "corne"]
status: "draft"
---

肩こり解消のために左右分割型の Corne Chocolate 自作することにしました。

自作キット付属外の BLE Micro Pro というパーツを別途使うことで、無線接続に対応させたものを作るのが目標です。

この記事は、初自作キーボードかつ電子工作初心者な私による 無線化 Corne Chocolate のビルドログです。

Corne Chocolate を選んだ理由や、揃えたパーツ・道具については前回の記事をご覧ください。

https://superhahnah.com/build-corne-chocolate-1/

## まずは表裏を決めて目印をつける

Corne Chocolate の電子基板(PBC)は裏表が同じで、どちらの面を表として使うかは最初に決めておきます。

作業途中でどっちがどっちかわからなくなるのを防ぐために、テープを貼ってマジックで左右裏表がわかるように印を書きました。

![マスキングテープで左右裏表の目印にする](/images/tech-blog/2023-build-corne-chocolate-2/front-sign.avif)

## 裏面にダイオードをつける

裏面にダイオードをハンダ付けしていくのですが、その前に、ハンダをつける金属端子部分(黄銅色の箇所)にフラックスという液体を塗りました。

フラックスることでハンダがつきやすくなるらしいです。  
別に使わなくてもいいのですが、私は学校の授業でやったときにハンダ付けが苦手だったので使うことにしました。

ちなみにハンダ自体にも多少フラックスが含まれているらしいです。（そうでないハンダもありますが。）

フラックスは、近い端子をまとめて塗りました。本当はひとつひとつやったほうがいいみたいだけれど、面倒だったのと、そんなに問題なさそうだったので。

![フラックスを端子に塗る](/images/tech-blog/2023-build-corne-chocolate-2/flux.avif)

１つのダイオードに対し2箇所ハンダ付けすることになるのですが、片側の端子にだけ事前にハンダをつけておきます。  
こういうのをいうのを予備ハンダというみたいです。

![予備ハンダ](/images/tech-blog/2023-build-corne-chocolate-2/pre-soldering.avif)

次に、ダイオードを向きを揃えて並べます。  
ダイオードにはプラス側とマイナス側があり、取り付け向きが決まっています。

![ダイオードを並べる](/images/tech-blog/2023-build-corne-chocolate-2/lined-diodes.avif)

ダイオードを片足だけハンダ付けします。  
ハンダごてにハンダを少しまとわせて、チョンと触れるだけどハンダがつきました。少量でOK。

ここでいったんチェック。向きが揃っているか、ダイオードが浮いていないか。浮いていたら、ハンダを溶かすとストンと下がって良い具合になりました。

![片足だけハンダ付けしたダイオード](/images/tech-blog/2023-build-corne-chocolate-2/half-set-diode.avif)

もう片足にハンダも付けしていきます。少量でOK。  
終わったらダイオードの向きが揃っているか、ハンダのつけ忘れがないかチェックします。

これで左右のPCBともダイオードを付け終わりました。

![ダイオードを付け終わった](/images/tech-blog/2023-build-corne-chocolate-2/diodes-set.avif)

## ピンソケット、リセットスイッチ、TRRSジャックをPCB(基板)の表面につける

これはを表面につけます。つまり裏面からハンダ付けします。  
こちらもハンダえ付けする箇所には事前にフラックスを塗りました。

高さの低い部品からひとつずつ取り付けました。裏側からハンダ付けする際に、部品が浮いた状態でハンダ付けしてしまうのを防ぐためです。  
ピンソケット、リセットスイッチ、TRRSジャックの順番です。

![ピンソケット、リセットスイッチ、TRRSジャック取り付け前](/images/tech-blog/2023-build-corne-chocolate-2/oled-reset-trrs.avif)

設置場所は

- ピンソケット: 「OLED」とプリントされている箇所
- リセットスイッチ: 「RESET」とプリントされている箇所
- TRRSジャケット: 「TRRS」とプリントされている箇所

ビンソケットは差し込むとゆるゆるで、裏面から作業するときに傾斜がついて浮いた状態でハンダ付けしてしまいそうだったので、適当なもので高さ調節し水平になるようにした状態でハンダ付けしました。

横から見るとこんな感じで高さ調節してました。

今思うと、マスキングテープで仮止めしてハンダ付けした方が楽で良かったと思います。

![ピンソケットの取り付け](/images/tech-blog/2023-build-corne-chocolate-2/setting-pin-socket.avif)

リセットスイッチとTRRSジャックは差し込んだ時点でガッシリしてたので高さ調節せずにそのままハンダ付けできました。

ちなみに後でわかったのですが、BLE Micro Pro を使う上ではリセットスイッチとTRRSジャックは不要でした。最終的には取り外しています。（付けてても問題ないです。）

## Pro　Micro の代わりに BLE Micro Pro を取り付ける

本来なら Pro Micro という部品を取り付けるところなのですが、今回はBlueTooth化するための部品 BLE Micro Pro を取り付けます。

![Pro　Micro と BLE Micro Pro](/images/tech-blog/2023-build-corne-chocolate-2/micro-pro-and-ble-pro-micro.avif)

画像真ん中上が自作キットに付属している Pro Micro (有線接続する場合に使うマイクロコントローラー)、右が BLE Micro Pro です。

画像左に写っているPCBの右上部分が取り付ける場所です。

画像中央下の金属棒と黒いプラスチックからできているものがピンヘッダで、PCBとマイクロコントローラーを繋ぐのに使います。

### スプリングピンヘッダを使う。ピンヘッダは使わない。

キットには 「Pro Micro + ピンヘッダ」がセットになって含まれているのですが、このピンヘッダは BLE Micro Pro においても流用できます。  
ただし、ピンヘッダよりもスプリングピンヘッダ(コンスルーとも呼ばれる)を使った方がいいです。どちらもキットに同梱されています。

| ピンヘッダ                                                                     | スプリングピンヘッダ                                                                            |
| ------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------- |
| ![ピンヘッダ](/images/tech-blog/2023-build-corne-chocolate-2/pin-headers.avif) | ![スプリングピンヘッダ](/images/tech-blog/2023-build-corne-chocolate-2/spring-pin-headers.avif) |

ピンヘッダだと基板側と BLE Micro Pro 側の両方ともハンダ付けが必要になります。  
スプリングピンヘッダを使うと、基板側と BLE Micro Pro 側のどちらもハンダ付けが不要です。スプリングピンヘッダでは、バネを使った機構により差し込むだけで外れにくくなってくれます。（スプリングピンヘッダに対応した穴に差し込むのであれば、です。）

ちなみに、 Pro Micro の場合はスプリングピンヘッダを使ったとしても、Pro Micro 側だけはハンダ付けが必要みたいです。

### まずはスプリングピンヘッダを取り付ける

まずは(スプリング)ピンヘッダを設置します。ピンヘッダの穴は左側に2列、右側にも2列用意されていますが、左右とも白枠で囲まれた列の方を使うとのこと。

(画像は再掲)
![ピンヘッダ取り付け位置](/images/tech-blog/2023-build-corne-chocolate-2/micro-pro-and-ble-pro-micro.avif)

#### 初めによく知らずに普通のピンヘッダを取り付けてしまった

初めはビルドガイドの通りにピンヘッダの方を取り付けました。  
（しかしスプリングピンヘッダを使った方がいいです。）

ピンヘッダの長いほうが上になるように表面側から設置し、裏面からハンダ付けしました。どちらの面に長い方が来るのが正解かわかりませんでしたが、ビルドガイドなどの画像を見ているとなぜか表側も裏側もピンが短くなっていたので、後でニッパーで切れば良いのかなと判断しました。  
(これは当たり前すぎて説明されない類のことなのかな。素人の自分はしばらく悩みました…)

![ピンヘッダを取り付け](/images/tech-blog/2023-build-corne-chocolate-2/set-pin-headers.avif)

ピンヘッダのハンダ付けは穴の間隔がとても狭くハンダ付けが難しかったです。隣どうしをハンダでくっつけてしまったりしました。こんな時は吸い取り線があるとミスした時にリカバリできます。

![ハンダ吸い取り線を使う](/images/tech-blog/2023-build-corne-chocolate-2/removing-solder.avif)

ここまできてようやく、ピンヘッダの他に似たようなもの(前述のスプリングピンヘッダ)が同梱されていたことに気づきました。

気になって調べてみたら、スプリングピンヘッダも使えるし、そちらの方が良いということが判明します。

#### スプリングピンヘッダに付け替えることを試みるも断念

スプリングピンヘッダを使った方が簡単に付けたり外したりできるので、今後メンテナンスする上で何かと便利そうだと思いました。  
なのでスプリングピンヘッダに付け替えることにしました。

吸い取り線を使ってハンダを取り除きます。ちょっと取り除いたくらいではピンヘッダは取れません。丁寧に取り除き、ラジオペンチで引っこ抜きます。

![ピンヘッダのハンダを取り除く](/images/tech-blog/2023-build-corne-chocolate-2/removing-solder2.avif)

![ラジオペンチでピンヘッダを引き抜く](/images/tech-blog/2023-build-corne-chocolate-2/pulling-pin-header.avif)

**…失敗しました。**

ピンがちぎれて、ピンホールが１つだけ埋まってしまいました。細い金具で突っついたりしましたが、復旧の兆しはありません。

![ピンホールが詰まった](/images/tech-blog/2023-build-corne-chocolate-2/jammed-pin-hole.avif)

#### ところで、OLEDモジュール用のジャンパのハンダ付けを忘れていた

OLEDモジュール？ キーを光らせるライトのことだろうな。光らせないし、関係ないな。

と思っていました。関係ありました。

OLEDモジュールというのは、キーボードに内蔵させるOLEDディスプレイのことだったのです。キットに付属しています。

幸いまだジャンパのハンダ付けは可能なので、事なきを得ました。

というか、そもそもOLEDに何を表示させるんだろうか？  
キーボードの内蔵ディスプレイに表示されて嬉しい情報が何なのかよく分からない。

今回作るキーボードは無線化してボタン電池を電源とするので、その電池残量がわかったら嬉しいかな。

なくても困らなさそうだけど、とりあえず設置できるようにハンダ付けしておきました。

#### ピンヘッダのリカバリーに戻る

ピンヘッダを抜き取るのは諦めて、新しいピンヘッダを刺すことにしました。

ピンホールが埋まっている箇所については、ピンをハンダ付けして無理矢理接続する作戦でいきます。

ピンにくっついている黒いプラスチック部分は邪魔になるので外して、2本のピンを接木のようにくっつけて長くします。

ピンヘッダの予備はなかったのでAmazonで購入しました。  
追加費用としては安いので気にしません。

この作戦は(おそらく)うまくいき、画像のようになりました。  
少しピンが斜めになっていますが良いでしょう。

![ピンヘッダのリカバリー](/images/tech-blog/2023-build-corne-chocolate-2/recover-pin-header-connection.avif)

### BLE Micro Pro をハンダ付けする

BLE Micro Pro が熱で壊れることが怖かったので温度を下げて250℃くらいにしました。

ピンが上に伸びてるままだとハンダが付きづらかったです。  
このピンは短くしても問題ないものと判断し、ニッパーで切りました。  
ピンをニッパーで短くしてからやるとうまくいきました。

ここまで過ちに過ちを重ねてきましたが、何とか BLE Micro Pro の取り付けができました。

![BLE Micro Pro をハンダ付け](/images/tech-blog/2023-build-corne-chocolate-2/set-ble-micro-pro-at-wrong-place.avif)

#### しかし新たな過ちが...

BLE Micro Pro のピンホールがなんか余ってるな〜と気づきました。  
他の方の組み立て風景を探してみると、USB端子に一番近い穴はPBCとの接続には使わないようです。電池と繋げる用の穴でした。  
なので１つズレてハンダ付けしてしまっていました。

ビルドガイドでは Pro Micro 向けの説明になっていいて穴が余ることはないのですが、それに気づかず、はめてハンダ付けするだけと安直に進めてしまいました。

吸い取り線でハンダを丁寧に取り除きます。  
伝熱時間が長くなるので BLE Micro Pro へのダメージが気になりますが、やむを得ません。

しかしこれでも全く外れる気配がなく。諦めそうになりました。

5時間くらいかかったかな？ これでもかというくらい何度も丁寧にハンダを吸い取り、てこで動かすとようやく取り外せました。良かった〜

![BLE Micro Pro を取り外した](/images/tech-blog/2023-build-corne-chocolate-2/removed-ble-micro-pro.avif)

[![HahnahのXポスト](/images/tech-blog/2023-build-corne-chocolate-2/hahnah-post.avif)](https://x.com/superhahnah/status/1653959514042015744)

#### BLE Micro Pro のハンダ付けを再開

先ほど取り付けミスして救出した方(左側用)は置いておいて、右側の方の BLE Micro Pro をハンダ付けしました。

![右側だけBLE Micro Pro をハンダ付け](/images/tech-blog/2023-build-corne-chocolate-2/set-right-ble-micro-pro.avif)

ミスから救出した方の BLE Micro Pro はまだハンダ付けしません。  
全体の組み立てがもう少し進んで、動作確認ができた段階でハンダ付けするようにします。

ハンダ付けしなくてもある程度の動作確認はできるようなので、その時点で壊れているかどうかを見て、状況に応じて買い直しなどの判断を柔軟にできるようにします。

- もし BLE Micro Pro が壊れているようなら新品の BLE Micro Pro を買い直します
- 逆に BLE Micro Pro が大丈夫でも基盤側がダメになっている場合には、PCBやダイオードなどを買い直すことで傷が浅く済みます
- 左側PCBのピンホールが埋まっている問題もあるので、PCBもBLE Micro Pro も買い直すこともあり得ます
- 心が折れたら、無線接続を諦めてキット付属の Pro Micro を使う手もあります
- BLE Pro Micro が壊れているケースの別選択肢として、右側用には LPME-IO を使うことにすればそれだけの追加購入で済みます。この場合キーボード同士は有線接続で、PCとは無線接続する構成になります。

X(旧Twitter)でアドバイスもらいながらこの作戦がたてれました。感謝！

## BLE Micro Pro 用電池基板の取り付け

### 電池基板自体の組み立て

BLE Micro Pro 用の電池基板には、片側分だけで次の部品があります。

- 基板
- スライドスイッチ
- ダイオード x2
- コンデンサ
- 電池ホルダー x2

![電池基板の部品](/images/tech-blog/2023-build-corne-chocolate-2/battery-holder.avif)

基板の穴や端子部分に合うように、部品をハンダ付けしていきます。

電池ホルダーの取り付け向きは、電池交換がしやすくなるように意識してベストな向きに決めました。  
しかし、それでも電池交換の際にはもしかしたらキーボードを一部分解する必要があるかもしれないなと若干不安があります。

まあ組み上がったらわかるでしょう。

![電池基板を組み立て](/images/tech-blog/2023-build-corne-chocolate-2/build-battery-holder.avif)

### BLE Micro Pro の上に電池基板を取り付ける

電池基板の「+」と BLE Micro Pro の 「BT」(バッテリー)を、  
「-」と「G」(グラウンド) をそれぞれ接続する必要があります。

参考にしたブログなどでは導線で繋いでいたのですが、持ち合わせていませんでした。

追加購入していた ピンヘッダが使えそうだったのでそれをハンダ付けすることで接続しました。

![電池基板の取り付け1](/images/tech-blog/2023-build-corne-chocolate-2/set-battery-holder1.avif)

BLE Micro Pro と電池基板が平行になるよう、間にピンヘッダーのプラスチック部分を抜き取った物を接着剤で設置しました(ちょうどいいサイズだったので)。

![電池基盤の取り付け2](/images/tech-blog/2023-build-corne-chocolate-2/set-battery-holder2.avif)

上に長くはみ出たピンは、電池の抜き差しに干渉しないようにニッパーで切り落としました。

![電池基盤の取り付け3](/images/tech-blog/2023-build-corne-chocolate-2/set-battery-holder3.avif)

この取り付け方法はかなりいいアイディアだったと思います。

### OLEDモジュールの取り付け

基板のOLEDモジュール用のソケットに、ピンヘッダを差し込み、ピンヘッダとOLEDモジュールをハンダ付けします。

キットの標準とは異なり電池基版を設置しているため、OLEDモジュールはその上に置くことになります。  
しかしそのせいでピンヘッダの長さが全然足りません。  
OLEDモジュール用に付属していたピンヘッダは短いのですが、他の長めのピンヘッダでも長さが足りなかったです。

![OLEDモジュールを取り付けようとするもピンヘッダの長さが足りない](/images/tech-blog/2023-build-corne-chocolate-2/try-to-set-oled-display.avif)

OLEDモジュールの取り付けは後でどうにかします。

### BLE Micro Pro をセットアップする

次は [BLE Micro Pro のガイド](https://github.com/sekigon-gonnoc/BLE-Micro-Pro/blob/master/docs/getting_started.md#ble-micro-pro-web-configurator%E3%82%92%E4%BD%BF%E3%81%86) を見ながら [BLE Micro Pro の Web Configurator](https://sekigon-gonnoc.github.io/BLE-Micro-Pro-WebConfigurator/) を使ってファームウェアの書き込みをやりました。

BLE Micro Pro を PC と接続し、Web Configurator を使っていきます。

- ブートローダーのインストール
- アプリケーションのインストール
- キーボード設定
- キーマップ設定

これらを左右それぞれのBLE Micro Pro でやることになります。  
ちなみにこの時、BLE Micro Pro にはコイン電池から電力供給してない状態でも大丈夫です。

初回の設定では、「ナビゲーション付きでセットアップを開始する」から進めるといいでしょう。

![Web Configurator でセットアップを開始する](/images/tech-blog/2023-build-corne-chocolate-2/web-configurator1.avif)

何やら選択する画面があらわれます。

![キーボードを選択する](/images/tech-blog/2023-build-corne-chocolate-2/web-configurator2.avif)

Corne Chocolate 用に設定するには 「Select Keyboard: crkbd」 にします。  
オプションについては自分は以下のようにしました:

- Disable Mass Storage Class
  - チェックを入れました。
    BLE Micro Pro をPCに接続すると大容量ストレージとして認識されるみたいなのですが、これにチェックを入れるとそうは認識されなくなります。ストレージ使いたい場面は想定できなかったので私はチェックを入れておきました。
- Use with LPME-IO
  - LPME-IO は今回使わないのでチェックを外したままにします。
    LPME-IO を BLE Micro Pro と組み合わせて使うと、左右のキーボードは有線接続でBLE Micro Pro とPCをBLE接続することができます。(マスター側がBLE Micro Pro、スレーブ側が LPME-IO の構成となります)

#### ブートローダーのインストール

次の画面ではブートローダーのバージョンを選びます。  
(画像では「Update Succeeded. Go next step.」と表示されていますが、これはブートローダーのインストール完了後のスクリーンショットになります。完了するとこのメッセージが表示されます。)

![ブートローダーのバージョンを選択する](/images/tech-blog/2023-build-corne-chocolate-2/web-configurator3.avif)

「Update」ボタンを押すとシリアルポート接続要求のダイアログが出ます。

![CorneChocolateのシリアルポートを選択する](/images/tech-blog/2023-build-corne-chocolate-2/web-configurator4.avif)

選択肢が複数出てきて、どれを選べばいいんだ？となったのですが、 BLE Micro Pro と接続している時/していない時で比較するとわかります。  
BLE Micro Pro のシリアルポートに接続したら「Update」を押して、ブートローダーのインストールがされます。

#### アプリケーションのインストール

続けてアプリケーションをインストールします。  
選択肢の中から最新バージョンを選びました。

![アプリケーションをインストールする](/images/tech-blog/2023-build-corne-chocolate-2/web-configurator5.avif)

#### キーボードの設定をする

今設定しているのは右側用に決めた BLE Micro Pro で、気持ち的にスレーブ(キーボード利用時にPCと通信しない方)にしたかったのでスレーブ用の設定をしました。  
(左右のどちらをマスター/スレーブにするかは自由です。)

![スレーブのキーボード設定](/images/tech-blog/2023-build-corne-chocolate-2/web-configurator6.avif)

- Show keymap.json using JP_XX
  - JIS配列で使う場合はチェックを入れる必要があります。私はチェックせず。というか、Corne Chocolate で JIS配列とかないよね？？
- Debounce
  - 一旦デフォルトの1にしました。チャタリングするようなら後で上げるみたいです。
- Auto Sleep
  - 電池交換の頻度を減らしたいので 30min に設定してみました
- Connection inteval (Peripheral)
  - マスターとスレーブ間の通信インターバルです
  - 一旦デフォルトの 30ms にしました

ちなみにマスター側に設定する場合はこんな画面です。

![マスター側のキーボード設定](/images/tech-blog/2023-build-corne-chocolate-2/web-configurator7.avif)

- Connection inteval (Central)
  - マスターとPCの通信インターバルです
  - スレーブにはない項目で、マスター側だけ設定します
  - デフォルトの 30ms にしました

#### 反対側も同じようにインストール・設定をする

キーマップの設定は別のツールでやることになるようなので後回しにし、反対側でもここまでと同様のことをやります。

左側、マスター(キーボード利用時にPCと通信する方)の方です。  
ブートローダーとアプリケーションのインストールをしようとしたのですが、「Update」ボタンを押したときに BLE Micro Pro　のポートが選択肢に出てこない...

しかもこんなポップアップが出るしわけがわからない。  
(このポップアップは出たり出なかったりする。出ている時はうまく接続できないっぽい？)

![USBアクセサリが無効](/images/tech-blog/2023-build-corne-chocolate-2/web-configurator8.avif)

ケーブルを何度も抜き差しするとようやくBLE Micro Pro のシリアルポートが接続できて、ブートローダーはインストールできました。

続けていくとアプリケーションのインストール時にまたシリアルポートの選択肢に出てこなくなった。

あれ？どうしたんだろう。

こちらはハンダ付けに失敗して取り外した方の BLE Micro Pro だったので、熱でいかれてしまっているんですかね...  
それかたった今壊れてしまったのか。

吸い取り線で取り外し作業した際に変な箇所にハンダがついてしまった可能性が考えられるので、 BLE Micro Pro をよくみて見ました。  
変にハンダが付いていてのショートした可能性も疑っている状況です。

遊舎工房のサイトに載っている BLE Micro Pro の画像と見比べてみます。

↓遊舎工房掲載の BLE Micro Pro (拡大画像、元画像は(https://shop.yushakobo.jp/products/ble-micro-pro より)
![遊舎工房掲載の BLE Micro Pro](/images/tech-blog/2023-build-corne-chocolate-2/sample-ble-micro-pro.avif)

↓自分のBLE Micro Pro
![壊れた BLE Micro Pro](/images/tech-blog/2023-build-corne-chocolate-2/broken-ble-micro-pro.avif)

すると、銀色の極小の物体?が2つ、ないではありませんか!?  
(↓の箇所)

![部品のない箇所](/images/tech-blog/2023-build-corne-chocolate-2/broken-ble-micro-pro2.avif)

ハンダで繋げればいいのか? それと何かの部品が取り付けられていたのか?

BLE Micro Pro をじっくり眺めて、同じような部品を見つけました。  
これは電池基板に取り付けたコンデンサの超極小バージョンのような見た目をしています。

おそらく積層セラミックコンデンサと呼ばれるものです。大きさは長辺でも1mmより小さく、肉眼でもスマホカメラでもよく見えないくらいです。

いらないデバイスの中からこれを見つけて、BLE Micro Pro に流用しようと考えました。  
かなり小さいコンデンサなので、精密電子機器に使われてそうな気がします。

もう使うことのないUSBメモリを分解すると...

![分解したUSBメモリ](/images/tech-blog/2023-build-corne-chocolate-2/usb-memory.avif)

...あった!!!たぶんこれだ!!!  
大きさもちょうどこれくらいな気がする。

![積層セラミックコンデンサ](/images/tech-blog/2023-build-corne-chocolate-2/multilayer-ceramic-capacitor.avif)

これを2つ取りました。ピンセットの先にある、ゴミみたいなやつです。

これを BLE Micro Pro にハンダ付けしていきます。

## おわった...

で、やってみたのですが、あまりにも高い精度が求められ、人間にできるとはとても思えなかったのでここで諦めました。

失敗に終わったのは残念ですが、できる限りのことはしたと思います。  
少し楽観的に始めすぎましたかね。経験も事前知識もほぼなかったです。

けれど、失敗をリカバリーするために考えを巡らせるのが楽しかったですし、知識や経験が余計についたのでそれは良かったです。  
安い勉強代ですな。

## 次回

ダメにしてしまった BLE Micro PRo や PCB などを買い足して再挑戦します。

https://superhahnah.com/build-corne-chocolate-3/

## 参考

- Corne Chocolate の組み立てマニュアル [https://github.com/foostan/crkbd/blob/main/corne-chocolate/doc/buildguide_jp.md](https://github.com/foostan/crkbd/blob/main/corne-chocolate/doc/buildguide_jp.md)
- スプリングヘッダを使う箇所のみ参考 [https://github.com/MakotoKurauchi/helix/blob/master/Doc/buildguide_jp.md](https://github.com/MakotoKurauchi/helix/blob/master/Doc/buildguide_jp.md)
- BLE Micro Pro の導入マニュアル [https://sekigon-gonnoc.github.io/BLE-Micro-Pro/#/getting_started?](https://sekigon-gonnoc.github.io/BLE-Micro-Pro/#/getting_started?)
- 電池基板のマニュアル [https://github.com/sekigon-gonnoc/BLE-Micro-Pro/tree/master/CoinCellHolder](https://github.com/sekigon-gonnoc/BLE-Micro-Pro/tree/master/CoinCellHolder)
- 電池基板の取り付け方参考 [https://blog.ottijp.com/2019/10/12/corne-cherry-ble-wireless/](https://blog.ottijp.com/2019/10/12/corne-cherry-ble-wireless/)
