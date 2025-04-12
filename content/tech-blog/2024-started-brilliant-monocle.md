---
title: "ARデバイス Brilliant Monocle と MicroPythonで組み込みプログラミングに入門してみた"
image: "/images/tech-blog/2024-started-brilliant-monocle/monocle-on-glasses.avif"
description: "自分のメガネを片目だけARグラスにする小型デバイスMonocleを紹介する。"
published: "2024-03-14"
updated: "2025-04-12"
category: "tech"
tags: ["ar", "smart-glasses", "brilliant-monocle", "micro-python"]
---

## Monocle とは

[Monocle](https://brilliant.xyz/products/monocle) は Brilliant Labs が発売するHUD (Heads Up Display)。  
「Monocle」という名の通り、片眼鏡のような形状をしていて、自分のメガネの片方に装着して利用する。

要は、自分のメガネを片目だけARグラスにする小型デバイスだ。

特徴として、Monocleの動作を自分でプログラムして利用するので自由度が高く、一般ユーザーではなく開発者向けなデバイスとなっている。

## ハードウェア

丸くて可愛らしいケースに入っていて、これがバッテリーチャージャーにもなっている。  
Monocle本体の見た目も なんかかっこいい。

![Monocleを外箱から出した](/images/tech-blog/2024-started-brilliant-monocle/box-opend.avif)

![Monocleのケースの大きさ](/images/tech-blog/2024-started-brilliant-monocle/monocle-case.avif)

![Monocleのケースを開けた](/images/tech-blog/2024-started-brilliant-monocle/monocle-case-opened.avif)

持ってみると手のひらに収まる小ささでとても軽い。  
Monocle本体は 15g の重量で、ケースは30g だ。AR系のデバイスでこれよりも軽量なものは流石にないのでは？ 知らんけど。  
(実測値は 15.2g と 30.9g)

![Monocleとケース](/images/tech-blog/2024-started-brilliant-monocle/monocle-and-case.avif)

Monocleのバッテリーは1時間持つらしく、ケースの方には本体を6回充電できるだけの容量がある。  
時々ケースに入れて充電しながら計7時間使える感じか。

他には、カメラ、マイク、タッチコントローラーがあり、Bluetooth 5.2 での接続に対応している。  
FPGAが使われている点は珍しいかもしれない。自分が手に取るものでFPGAが使われているのを認識したのは初めてだ。

![Monocle Hardware](/images/tech-blog/2024-started-brilliant-monocle/monocle-hardware.avif)
(画像は [https://docs.brilliant.xyz/monocle/hardware/](https://docs.brilliant.xyz/monocle/hardware/) より)

スペック詳細はこんな感じ([https://docs.brilliant.xyz/monocle/hardware/](https://docs.brilliant.xyz/monocle/hardware/) より)。

> 640x400 color OLED display
> 20° FOV optical body
> 5MP camera
> Microphone
> FPGA based acceleration for ML/CV
> Bluetooth 5.2
> 70mAh rechargeable Li-ion battery
> Touch buttons
> Full featured MicroPython based OS
> Charging case with USB & 450mAh battery

## 開発の準備

基本的に [ドキュメント](https://docs.brilliant.xyz/monocle/monocle/) の通りにやれば問題ないんだけど、ちょっとわかりにくい部分もある。  
トラブルにあったら、Discordで調べるなり聞くなりするといい。  
みんなかなり活発に質問していて、遠慮なく聞けそうな雰囲気でグッド。

### まずはファームウェアアップデートをした

(これは飛ばしても大丈夫な可能性あり)

一旦 Web REPL を開き、Monocle と Bluetooth接続する

購入直後のMonocleはファームウェアが最新でなかったので、Web REPL の右下の方のテキストボタンをクリックしてファームウェアアップデートをした。

そうしないと単純なサンプルコードすらも動かない。  
実は自分はこれでつまづいて、「なんや、全然動かんやんけ！」と購入後1年くらい寝かせてたw

REPLから、Monocle内の MicroPython のアップデートもした。

```python
 import update
 update.micropython()
```

(実はこれらのアップデートは次に書く Brilliant AR Studio を使っていれば自動でされるらしい。けど自分は1年前当時、何度トライしても自動アップデートされてなかったぽくて、初歩的なサンプルコードが動かず、表示も変だったのでつまづいたのだと思われる。たぶんバグがあったんだろうな。)

### 開発環境を用意する

Web REPL でも開発できるんだけれども、Visual Studio Code を使うようにした。  
Brilliant AR Studio というプラグインを使うので VS Code にインストールしておく。  
これで準備は完了。

### サンプルコードを動かしてみる

とりあえずこのページにある[サンプルコード](https://docs.brilliant.xyz/monocle/building-apps/)を動かしてみる。

1. VS Code と Monocle をBluetooth接続(VS Code で `Brilliant AR Studio: Connect` コマンド)する。
2. Monocle用に新規プロジェクトを作成（`Brilliant AR Studio: Initialize new project folder` コマンド）する。
3. main.py にサンプルコードをペーストし保存
4. main.pyを右クリックして `Brilliant AR Studio: Upload File To Device` を選択することで Monocle にファイルアップロード (このステップはなくても問題なく動かせてる気がする)
5. `Brilliant AR Studio: Build`コマンドでビルドする

```python
import touch
import display

def change_text(button):
    new_text = display.Text(f"Button {button} touched!", 0, 0, display.WHITE)
    display.show(new_text)

touch.callback(touch.EITHER, change_text)

initial_text = display.Text("Tap a touch button", 0, 0, display.WHITE)
display.show(initial_text)
```

これで、Monocleに "Tap a touch button"、 と表示され、タッチしたボタン(２つある)に応じてテキストが変わると言う簡単な挙動をするようになる。

コードに出てくる`touch`モジュールや`display`モジュールが鍵で、タッチをハンドリングしたりディスプレイ表示をコントロールしたりできる。

他になんかそれっぽいモジュールがいくつかあって、Monocleに何ができるのかが何となくイメージできる。  
APIリファレンスを見るといい。  
[https://docs.brilliant.xyz/monocle/micropython/](https://docs.brilliant.xyz/monocle/micropython/)

`touch`, `display`, `camera`, `microphone`, `bluetooth`, `time` とかあるね。

## Noa で Monocle を AIアシスタント化する

Monocle はモバイルアプリ、ウェブアプリと連携させることができ、それを通して外部サービスのAPIやサーバーと連携させることも可能。

その一例として、Brilliant Lab が提供する Noa と言うアプリがある。(iOS/Androidのアプリ)

Noaを使うには、自分でOpenAI API のAPIキーを発行する必要があるので注意。  
一部機能を使うには Stability AI の APIキーも必要。

Noa と Monocle でできること:

- AIとの会話、質問など、AIアシスタント的使い方(返答がMonocleディスプレイに表示される。また、Noa側にも会話は表示される)
- Monocleのマイクが聞いた外国語を翻訳してMonocleディスプレイ上に表示する(英語への翻訳)
- Monocleで写真撮影し、それをAIで加工してもらう。加工指示は口頭。
  - 2024年3月時点ではiOS版Noaでは画像加工ができなかった。iOS版Noaが使っているStability AIのAPI仕様変更に追随できてない。Android版ではできるらしい

![Noaの画面](/images/tech-blog/2024-started-brilliant-monocle/noa.avif)

仕組みとしては多分だが、  
NoaはMonocleからBluetooth接続で音声情報を受け取る。それを OpenAI APIにかまして返答文を作成する。それがNoaからMonocleに送られ、Monocleのディスプレイにテキスト表示される。

画像加工には Stability AI のAPIが使われている。（Stable Diffusion のモデルを使っているというとわかりやすいか)

Monocle が モバイルアプリ(Noa)と Bluetooth で連携し、モバイルアプリはサーバーや外部サービスのAPIと連携させられるので、これにより凝ったことが実現できるわけだ。

## Monocole の挙動について

Monocleはケースから取り出すと起動する。  
起動後、MicroPythonで main.pyのプログラムが実行される。

Monocleには1つのプログラムしか記憶させておけないので、一見すると複数の異なるプログラムを利用者が使い分けることはできないように思える。  
(日常の利用シーンで、プログラムを切り替えたい時に毎度開発ツールでビルドしなおすわけにはいかない)

けれど実際にはそんなことはなく、うまくやる方法がある。

例えば Noa では、NoaのモバイルアプリをMonocleをペアリングした時点で（またはそれ以降でも、ペアリング済みのNoaを起動した時点で）、MonocleがNoa用の挙動をするようになる。  
これはNoaがMonocleにNoa用のMicroPythonコードを送り、それをビルドする命令も送っているのだと推測される。（NoaはOSSなので調べれば答えは分かるはず。）

つまり、Monocleの利用ケースごとにモバイルアプリないしはWebアプリを用意しておき、そのアプリがMonocle側の挙動もセットしてあげるようにすることで、ユーざーは1つのMonocleで複数の異なるプログラムを使い分けることができる。

## 最後に

Monocleでなんか色々できそうなのでやってみたいな。  
それと、Monocleを積んでた間に実は同社から　[Frame](https://brilliant.xyz/products/frame) と言うAIグラスも発表され、こちらも気になって予約してしまった。
