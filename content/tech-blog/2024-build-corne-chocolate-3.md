---
title: "肩こり解消のために無線分割キーボード Corne Chocolate を自作する〜③再挑戦編〜"
image: "/images/tech-blog/2024-build-corne-chocolate-3/key-switches-set.avif"
description: "失敗した無線化Corne Chocolateの自作に再挑戦しました。"
published: "2024-04-29"
updated: "2025-04-12"
category: "tech"
tags: ["keyboard", "self-made-keyboard", "corne"]
---

## 前回までのあらすじ

前回までの記事はこちらです。

[肩こり解消のために無線分割キーボード Corne Chocolate を自作する〜①選定・準備編〜](https://hahnah.github.io/tech-blog/2023-build-corne-chocolate-1/)

[肩こり解消のために無線分割キーボード Corne Chocolate を自作する〜②作成失敗編〜](https://hahnah.github.io/tech-blog/2023-build-corne-chocolate-2/)

肩こり解消のために左右分割の無線接続キーボードを組み立てようとしました。  
Corne Chocolate にマイクロコントローラーとして BLE Micro Pro を使った構成です。

組み立て時の失敗をなんとかリカバリーしながら進められていたものの、さらに失敗して結果的に BLE Micro Pro が1つ壊れてしまいました。

PCBについてはピンホールの1つがハンダで埋め固まってしまい、そのハンダを取り除くことはできませんでした。

こうして失敗しリカバリー不可能になったところで前回は終わりました。

(この記事の内容は1年弱前にやったことなんだけど、記事を書き上げるまでに長い時間が経ってしまった...)

## ダメにした部品を買い直す

左側キーボード用にしていたPCBと BLE Micro Pro、その他部品を再度購入しました。

もともとは Corne Chocolate の自作キーボードキットを購入していたので必要な部品がだいたい付属していたのですが、今回はバラ売りのものを買います。

![バラ売りのパーツを再度購入](/images/tech-blog/2024-build-corne-chocolate-3/buy-again.avif)

この画像にない部品は失敗したPCBから取り外して再利用しています。  
(OLEDモジュール用のピンソケットなど)  
ダイオードもPCBから取り外せば使いまわせるのですが、数が多くて面倒なのと安価なことから、そうはしませんでした。

また、ダメにした部品以外には黄銅スペーサー(15mm)を購入しています。  
これはマイクロコントローラー、電池基板、OLEDモジュールのスペースの上から重ねる、保護プレートを固定するためのスペーサーです。

キット付属外の電池基板を取り付けるようにしていることから、キット付属のスペーサー(8mm)では高さが足りないことが前回の組み立て時にわかっていました。

自分の組み立て具合に合うように定規で計測して15mmのスペーサーを買いました。

## 前回失敗した左側を組み立て直す

買い直した部品を使って、左側キーボード用に前回やったところまで組み立てを進めました。  
PCBにダイオード、OLEDソケット、リセットスイッチ、BLE Micro Pro、電池基板 を取り付ける所まで進めました。

![左側を組み立て直した1](/images/tech-blog/2024-build-corne-chocolate-3/rebuild-left-side1.avif)

![左側を組み立て直した2](/images/tech-blog/2024-build-corne-chocolate-3/rebuild-left-side2.avif)

![左側を組み立て直した3](/images/tech-blog/2024-build-corne-chocolate-3/rebuild-left-side3.avif)

右側については前回組み立て済みで、ブートローダー・アプリケーションのインストールと、キーボード設定も済んでいます。  
(残すはOLEDモジュールの取り付けとキーマップの設定のみ)

## ブートローダーとアプリケーションをインストールする

左側用の BLE Micro Pro にブートローダーとアプリケーションを書き込みました。  
書き込みには前回同様に [BLE Micro Pro Web Configurator](https://sekigon-gonnoc.github.io/BLE-Micro-Pro-WebConfigurator/) を使いました。

前回はファームウェア書き込みしようとした時に BLE Micro Pro が認識されず、故障しているようだと判明して終了しました。

ブートローダーの更新とアプリケーションの更新は成功。  
設定内容は前回記事と同様です。

## キーボード設定を書き込む

左側用の BLE Micro Pro にキーボード設定を書き込みしようとしました。

しかし失敗したようです。

![キーボード設定の書き込みに失敗](/images/tech-blog/2024-build-corne-chocolate-3/keyboard-setting-failed.avif)

> Failed to Update Check log for datail.

というエラーメッセージが出ます。  
どこでログ確認すべきなのかよくわかりませんが、Chrome devtools のコンソールを見ると次のエラーログが出てました。

> Unchecked runtime.lastError: A listener indicated an asynchronous response by returning true, but the message channel closed before a response was received

Chrome 拡張を全て無効化し、さらに Experimental Web Platform features も無効化してリトライしてみましたが、「Failed to Update Check log for datail.」というエラーが相変わらず Web Configurator 上に出ます。

Chromeのコンソールには先ほどの「Unchecked runtime.lastError: ...」のエラーは出なくなり、これ以上解決につながりそうなログは見当たりませんでした。

USB-Cケーブルを変えてみたり、ブートローダーやアプリケーションの再インストールを繰り返しているうちに、キーボード設定の書き込みが成功するようになりました。

とりあえず成功しましたが、謎です。

もしかしたら自分の勘違いで、アプリケーションの書き込みができてなかったのかもしれません。  
ファームウェア書き込み後、アプリケーションを書き込んだつもりで Skip してしまっていたんでしょうか？  
今となってはわかりません。

ちなみにUSB-Cケーブルに MacBook Pro 付属の太いやつを使うと、Chrome が BLE Micro Pro　を認識すらできなかったので、ケーブルの相性もあるみたいです。

「Update Succeeded. Go next step.」のメッセージを見た時はほっとしました。  
1つ約5000円もする BLE Micro Pro を買い替えたのに、また失敗したのかと気分が沈みかけていましたが、なんとかなりました。

## キーマップを書き込む

マスターの BLE Micro Pro (自分の場合は左側用) をPCに接続して、今度はキーマップの書き込みをしていきます。

BLE Micro Pro のキーマップ書き込みには次の2つのツールが推奨されています(当時)。どちらもWebブラウザで使うツールになっています。

- [Remap](https://remap-keys.app/)
- [QMK Configurator for BLE Micro Pro](https://sekigon-gonnoc.github.io/qmk_configurator/#/0_sixty/base/LAYOUT_1x2uC)

Remapの方が機能がたくさんアピールされていたのとUIがみやすかったので気になっていました。

![remapのUI](/images/tech-blog/2024-build-corne-chocolate-3/remap-ui.avif)

しかし当時のRemapにはバグがあり、キーが正しく認識されないようです。  
なので今回は QMK Configurator を使うことにしました。

![remapのバグ](/images/tech-blog/2024-build-corne-chocolate-3/remap-bug.avif)

Remap のバグの GitHub issue: [https://github.com/remap-keys/remap/issues/751](https://github.com/remap-keys/remap/issues/751)

**※ Remapのこのバグは2023/9/11に修正されました。**  
**※ 2024年2月現在ではRemapが推奨です。また自分が試したところ QMK Configurator for BLE Micro Pro ではキーマップが正常に書き込めなくなっていました。**

キーマップは組み立て終わってからじっくり考えたいので、適当なキーマップをとりあえず設定しておきたい状況です。  
組み立てがもう少し進んだときに動作確認ができる最低限の設定だけできれば今は十分なので。

しかし QMK Configurator にはデフォルトキーマップは用意されておらず、ここまでセットアップした BLE Micro Pro にもキーマップは何も設定されていない状態です。

一旦、QMK Configurator で適当にキーマップを設定しました。

### QMK Configurator でキーマップ設定していく

QMK Configurator の画面は最初以下のようになっています。

![QMK Configurator](/images/tech-blog/2024-build-corne-chocolate-3/qmk-configurator.avif)

まず、BLE Micro Pro をUSBケーブルでPCと接続した状態で「CONNECT BY SERIAL」というボタンを押すと、接続しているBLE Micro Pro の設定が読み込まれて「KEYBOARD」が自動で選択されます。（この場合は「Corne」になる。）

もしそのキーボード用のデフォルトキーマップが用意されている場合は、「LOAD DEFAULT」ボタンでそれを読み込めるようです。  
しかし残念ながらこの自動選択された「Corne」のデフォルトは未登録でした。

一つずつ適当にキーを登録していくことにしたのですが、どうやるのかがUIから読み取れず困ってしましました。

以下の画像のように「0 keys」と表示されており、自動選択された「Corne」には正しく登録されていないようです。困りました。

ふと、「KEYBOARD:」のプルダウンで「crkbd/rev1」というものを見つけたのですが、これはブートローダー書き込みなどの時にも見た字面です。これが正解では？

「crkbd/rev1」にすると以下の画像のように表示がされるようになり、Corne Chocolate と一致するので合ってそうです。

しかし、[BLE Micro Pro のドキュメント](https://sekigon-gonnoc.github.io/BLE-Micro-Pro/#/getting_started?id=qmk-configurator%e3%82%92%e4%bd%bf%e3%81%86%e5%a0%b4%e5%90%88usb%e6%8e%a5%e7%b6%9a) に(当時)書かれてあった、

> キーマップの書き換えにはBLE Micro Pro用の変更を加えたQMK Configuratorを使います。

というのが気になります。
この「crkbd/rev1」というのは、普通の Pro Micro を使った場合のもので BLE Micro Pro には適合しないのでは、という懸念がありました。

とりあえず、一旦これで設定してみてうまくいくか試すことにしました。

「CONNECT BY SERIAL」 というボタンの左にあるボタンを押すことでキーマップの設定を書き込めるのですが、このボタンが disabled になっていて押せません...

これは一旦「CONNECT BY SERIAL」し直して、「CORNE」として認識させた後にもう一度手動で「crkbd/rev1」を選び直すことで押せるようになりました。

そして、キーマップ設定の書き込み自体は成功しました！

## キーマップ設定が書き込めたか確認する(左側)

書き込んだ通りのキーマップになっていそうかをテストします。  
ピンセットで「T」(であるはず)の箇所を導通させて、「T」のキーが押されたことにします。

![キーマップの導通確認](/images/tech-blog/2024-build-corne-chocolate-3/checking-sockets.avif)

すると、QMK Configurator 上にログが出力されます。

![QMK Configurator で KC:23 のログが出力される](/images/tech-blog/2024-build-corne-chocolate-3/log-on-qmk.avif)

> ---- action_exec: start -----
> EVENT: 0005u(42387)
> Process KC:23
> ACTION: ACT_LMODS[0:17] layer_state: 00000000(0) default_layer_state: 00000000(0)
> processed: 0005u(42387):0

「Process KC: 23」とあるのでキーコードが23ということだろうか？

「Space」キーであるはずの場所を導通させると以下のログが出ました。

> ---- action_exec: start -----
> EVENT: 0305u(48123)
> Process KC:44
> ACTION: ACT_LMODS[0:2C] layer_state: 00000000(0) default_layer_state: 00000000(0)
> processed: 0305u(48123):0

キーコードは以下に記述されているものなのですが、これらを見ても照合できず結局よくわかりませんでした。

- [QMKの基本的なキーコード](https://docs.qmk.fm/#/keycodes)
- [BLE Micro Pro 独自のキーコード](https://sekigon-gonnoc.github.io/BLE-Micro-Pro/#/edit_keymap_file?id=ble-micro-pro%e5%9b%ba%e6%9c%89%e3%81%ae%e3%82%ad%e3%83%bc%e3%82%b3%e3%83%bc%e3%83%89)

ひとまず、マスター(左側用)にキーマップ設定が書き込めたことは確認できたので良しとします。  
(正しく書き込めているのかは確認できませんでしたが、後でわかるものと期待して先に進みます。)

最後に、「&#x1f4be; KEY_MAP」というボタンを押すことで BLE Micro Pro に設定が保存されるます。  
(これをしないと、USBを抜くと設定が消えちゃいます)

## スレーブ(右側用)の BLE Micro Pro にもキーマップ設定を書き込む

同様にスレーブの BLE Micro Pro にもキーマップ設定を書き込み、保存しました。  
スレーブはキーを導通させても、マスターの時のようなログは出ませんでした。  
スレーブ単体だと、QMK Configurator 上でも確認できないのだと推測しました。

書き込み時、保存時、QMK Configurator への再接続時のログからはきちんと書き込めてそうなので、良しとします。

## OLED モジュールの取り付け

OLEDモジュールを左右両方の基盤に取り付けていきます。  
(ちなみにこの呼び名は、おそらくOLEDディスプレイモジュールの略称ですかね。自分はしばらくの間、チカチカ光るOLEDライトのことかと勘違いしていたw)

OLEDモジュールの裏面が電池ホルダーと触れないように、絶縁テープを貼っておきます。

![OLEDの表面](/images/tech-blog/2024-build-corne-chocolate-3/oleds.avif)

![OLEDの裏面に絶縁テープを貼る](/images/tech-blog/2024-build-corne-chocolate-3/taped-oled.avif)

ソケットにピンヘッダを差し込み、そのピンヘッダにOLEDモジュールをハンダ付けする流れなのですが、ここで問題があります。

電池基板を設置しているせいでピンヘッダが全然OLEDモジュールに届かないのです。

![OLEDまでピンヘッダが届かない](/images/tech-blog/2024-build-corne-chocolate-3/pins-too-shot-for-oled.avif)

手持ちのソケット、ピンヘッダを組み合わせてなんとかいい感じの高さにOLEDモジュールが来るようにしました。

画像はまだハンダ付けしてないけど、こんな感じになります。  
OLEDモジュールを設置してもボタン電池の抜き差しができるのかも確認しました。  
(ボタン電池がOLEDモジュールのソケットと干渉するのを懸念してましたが、ギリギリ大丈夫でした。)

![2つのピンヘッダを繋ぎ合わせた](/images/tech-blog/2024-build-corne-chocolate-3/diy-connected-pin-headers.avif)

左右とも設置できたら、OLEDモジュールの表示を確認します。

ボタン電池を入れて、電源スイッチも入れ、ピンセットでキースイッチの端子を導通させます。  
でもOLEDモジュールに何も表示されない...

これまで、BLE Micro Pro が QMK Configurator では動作することを確認できていたので、問題があるとすればOLEDモジュールか電池基板周りです。

電池基板のドキュメントを見返していて、電池ホルダーの金属2枚が触れないようにとの注意書きがあったのに気づき、実際隙間がほとんどなかったのでニッパーで少し切りました。

それをしても変化はなし。QMK Configuratorでの確認は相変わらずできているので、電池ホルダーの金属がふれていたために壊れたということもなさそうです。

「BLE Micro Pro のマスターとスレーブがペアリングできてないから」という仮説も考えましたが、調べたところによると両方とも電源ONになっていれば自動的にペアリングされるようです。

とりあえず、左右とも電源ONにして、Macから検出できるか確認してみました。

![CorneがMacで検出された](/images/tech-blog/2024-build-corne-chocolate-3/corne-detected.avif)

「Corne」が検出できています！  
ピンセットでマスターのキーの端子を導通させると、PCに文字が打ち込まれました。  
しかし、スレーブ側のものを導通させても反応がありません。

やはりマスターとスレーブのペアリングがされてないのでしょうか？

一応、スレーブを QMK Configurator に接続し、ピンセットを使って導通確認を再度やってみます。  
すると、あれ...?? 接続はされますし、接続時や設定書き込み時のログは出るのですが、キースイッチの端子を導通させた時にログが出ません。  
おかしいな、さっきまで大丈夫だったのに。

ブートローダーとアプリケーションをもう一度書き込み直して、Configとキーマップも書き込み直してみましたが状況は変わらずでした。

左右のキーボードの電源を入れ直したりMacに接続し直したしていると、右側のキーボードでも入力がされるようになりました。

一体何だったのか謎ですが何はともあれ、全てのキーの端子について導通テストをし、Macに入力される文字が設定通りなことが確認できました。

しかし、OLEDモジュールには相変わらず何も表示されません。左右ともです。  
OLEDのジャンプもハンダできてるのでその点は問題なさそうです。

OLEDモジュールとPCBをつなげているソケットとピンヘッダに問題がある可能性を考えて、一度同線で繋いてテストしてみましたが、それでもだめでした。

TRRSソケットを使わないからと取り外したのですが、これを取り付けることで必要な回路がつながるようになっている可能性もあるかと思って試したがこれも関係ありませんでした。(まあそうだよな)

Web上で調べたところ、どうやらOLEDモジュールとファームウェアの相性によってはOLEDモジュールが点かないようです。  
参考: [https://kochikbd.hatenablog.com/entry/2020/11/08/001947](https://kochikbd.hatenablog.com/entry/2020/11/08/001947)

自分のOLEDモジュールは上記記事で点かなかったのと同じタイプのものっぽいが、当時流石に最新版のファームウェアの問題は解消されてそうなので違う気がする。

原因切り分けできるほどのものが周りにないので、OLEDモジュールは諦めました。  
必須ではないですしね。

## スイッチソケット の取り付け

PCBの裏側にスイッチソケット(今回のは Kailh Switch Socket というやつ)を取り付けていきます。

![Kailh Switch Sockets](/images/tech-blog/2024-build-corne-chocolate-3/kailh-switch-sockets.avif)

まず、PCB裏側にあらかじめハンダを乗せていきます。後から追加するのは難しいみたいなので、これは多めに乗せておいた方がいいようです。

Corne Chocolate は 左右合わせて42キーで、1キーにつき2箇所ハンダづけする箇所があるので、84箇所にハンダを乗せました。

![スイッチソケット用にあらかじめハンダを乗せる](/images/tech-blog/2024-build-corne-chocolate-3/pre-soldered-for-switch-sockets.avif)

そうしたら、裏面からスイッチソケットをはめ込み、先程のハンダを溶かすようにしてハンダ付けしていきます。
スイッチソケットが浮かないようにピンセットで押さえながら作業します。

![スイッチソケットの半田付け](/images/tech-blog/2024-build-corne-chocolate-3/sodering-switch-sockets.avif)

キーを強くタイプするとこのスイッチソケットが外れたりするんじゃなかろうかと心配だったので、自分は追いハンダも加えてしっかり目に固定しました。

![スイッチソケットのハンダ付け完了](/images/tech-blog/2024-build-corne-chocolate-3/complete-switch-sockets-soltering.avif)

## OLEDモジュールの上にプレートを固定

スペーサーをネジ止めしてOLEDモジュールの上にプレートを取り付けます。  
写真の銀色の円柱(実際は円筒形)のものがスペーサーです。今回は電池基板を追加していることから、高さ15mmのスペーサーを利用しています。ちなみにキット付属のスペーサーは高さ9mmです。  
(この写真では点かないOLEDモジュールを一応取り付けています。)

![OLEDモジュールの上にプレートを固定](/images/tech-blog/2024-build-corne-chocolate-3/set-oled-plate.avif)

## トッププレートとボトムプレートの設置

プレートは側面が白っぽくなっているのですが、この部分はマジックで黒く塗りました(見栄えのため)。

ボトムプレート(平なプレート)にスペーサー(長さ4mm)をネジ止めしていきます。  
そうしたら、ボトムプレートの上にPCBとトッププレートを重ねていき、トッププレートとスペーサーをネジ止めします。  
以下のようになリます。

上：トッププレート (キーをはめ込む穴があるプレート)  
中：PCB  
下：ボトムプレート

の順に重なるようにして固定していきます。各プレートの間にはスペーサー(長さ4mm)を入れてネジ止めします。

![トッププレートとボトムプレートの取り付け中](/images/tech-blog/2024-build-corne-chocolate-3/setting-bottom-and-top-plates.avif)

取り付け完了するとこんな感じ↓
![トッププレートとボトムプレートの取り付け完了](/images/tech-blog/2024-build-corne-chocolate-3/complete-setting-bottom-and-top-plates.avif)

裏から見るとこんな感じ↓
![トッププレートとボトムプレート取り付け完了した姿を裏から見る](/images/tech-blog/2024-build-corne-chocolate-3/bottom-plate.avif)

## キースイッチをはめ込む

キースイッチをはめ込んでいきます。パッチと音がして固定されるまではめ込みます。  
キースイッチには向きがありますが、簡単に判別できます。  
キースイッチの2本の金属端子がキーソケット(PCBに裏面から取り付けたもの)に差し込むようにします。

![キースイッチをはめ込んだ](/images/tech-blog/2024-build-corne-chocolate-3/key-switches-set.avif)

### ちなみ私が選んだキースイッチは

ちなみに、私が購入したキースイッチは 「Kailh ロープロファイルスイッチ」 の 「Red Pro」 という軸のものです。

![Kailh Switch Red Pro](/images/tech-blog/2024-build-corne-chocolate-3/kailh-switch-red-pro.avif)

キースイッチ中央の「軸」と呼ばれる部分が色付けされているのですが、この軸色毎に異なる打鍵感を持ちます。(色によって内部のバネが異なる)

> 赤軸：スムーズなリニア軸
> 茶軸：クリック感のあるタクタイル軸
> 白軸：カチカチ感のあるクリッキー軸
> Red Pro：軽くてスムーズなリニア軸
> Pink：さらに軽くてスムーズなリニア軸
> (https://shop.yushakobo.jp/products/pg1350 より)

私は遊舎工房の店舗で、キースイッチのテスター(いろんなキースイッチが並んでいて打鍵感を試せるやつ)で感触を確かめて、 Red Pro が好みだったのでこれに決めました。

## 滑り止めシールを貼る

裏面の四隅に滑り止めシールを貼ります。

![滑り止めシールを貼り付け](/images/tech-blog/2024-build-corne-chocolate-3/legs.avif)

## キーキャップを取り付ける

キースイッチにキーキャップを取り付けていきます。  
今回使うキーキャップは、[MBK Choc Low-Profile Keycap](https://shop.yushakobo.jp/products/mbk-choc-low-profile-keycaps) です。

Corne Chocolate では 1U のキーキャップが40個、1.5U のキーキャップが2個必要になります。  
1Uは通常の正方形のキーキャップの大きさを表しています。1.5Uは幅がその1.5倍あります。

今回は以下のものを用意しました:

- 1U
  - パステルグリーン x 30個
  - ターコイズ x 10個
- 1.5U
  - 白 x 2個 (本当はこれもターコイズにしたかったけど、白と黒しか在庫がなかった)

色んなキーキャップを組み合わせて自分好みにできるのはいいですね。

このキーキャップに向きがあるのかはわからないですが、一応裏面の文字を見て「こっちが上だろうな」と見分けてからキースイッチにはめ込みました。

![キーキャップを取り付け](/images/tech-blog/2024-build-corne-chocolate-3/set-keycaps.avif)

## 動作確認する

キーマップのカスタマイズを除けば一旦これで完成です！！！

動作確認をして、ちゃんとキーボードとして使えてました。ちょっと感動。

## 次回

次で最後です。自分好みのキーマップを考えて、設定します。

[肩こり解消のために無線分割キーボード Corne Chocolate を自作する〜④キーマップ設定編〜](https://hahnah.github.io/tech-blog/2024-build-corne-chocolate-4/)
