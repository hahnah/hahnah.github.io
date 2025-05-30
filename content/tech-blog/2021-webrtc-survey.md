---
title: "WebRTCで必要になるもの"
# image: "/images/tech-blog/slug/image.jpg"
description: "WebRTCを利用するために何が必要となるのか調査した。個人的なモチベーションとしては、1対１のボイスチャットを想定してた場合に自分で構築・運用できるようなものなのか知りたかったので、調査範囲としては ほどほど。"
published: "2021-05-26"
updated: "2025-05-30"
category: "tech"
tags: ["web-rtc"]
---

## TL;DR

#### 必須

- シグナリングサーバー は必須
- LAN内のP2P用途ならサーバーとしてはこれだけでOK

#### クライアント同士が異なるLANにある場合

- 加えてSTUNサーバーを使う
- (全部ではないけれど) NATを超えてP2Pできるようになる
- とりあえずここまで用意すれば70%くらいのケースで繋がるらしい

#### クライアント同士が異なるLANにある場合で、カバーできる環境を広げたい場合

- 加えてTURNサーバーを使う
- Symmetric NAT や ファイアーウォールを超える必要があるケース
- P2Pではなくなり、TURNサーバーがパケットをリレーする
- 転送量に注意
- STUN と TURN を適宜使い分けるような仕組みにもできる (ICE)

#### 1対１でなく、複数人のコミュニケーションに使う場合

- 加えてSFUサーバーを使うことが推奨される

#### サーバー側での録音・録画などの要件がある場合

- SFUサーバーを使った上でそれをすることになる

## WebRTC とは

WebRTC (Web Real-Time Communications) は Webブラウザ同士でのリアルタイムコミュニケーションを実現するための仕組みである。  
ここでいうリアルタイムコミュニケーションとは、リアルタイムに映像や音声、それ以外にも任意のデータを送り合うこと。

> WebRTC (Web Real-Time Communications、ウェブリアルタイムコミュニケーション) は、ウェブアプリケーションやウェブサイトにて、仲介を必要とせずにブラウザー間で直接、任意のデータの交換や、キャプチャしたオーディオ／ビデオストリームの送受信を可能にする技術です。 WebRTC に関する一連の標準規格は、ユーザーがプラグインやサードパーティ製ソフトウェアをインストールすることなく、ピア・ツー・ピアにて、データ共有や遠隔会議を実現することを可能にします。
> (https://developer.mozilla.org/ja/docs/Web/API/WebRTC_API より)

ちなみにだが WebRTC は 実は P2P (Peer to Peer) でない場合があったりもする。Webブラウザ以外で利用することもできる。

WebRTCの利用は、フロントエンドの実装としては Web標準となっている [WebRTC API](https://developer.mozilla.org/ja/docs/Web/API/WebRTC_API) を使うだけの小さなコードで済んでしまう。

## WebRTCのためのサーバー

WebRTCのためのバックエンドはどうなるだろうか。用途や利用環境に応じていくつかのサーバーが必要となるのだが、それを紹介していく。

### シグナリングサーバー

フロントエンドだけがあっても、通信したい相手のIPアドレスなどの情報がなければ通信できない。  
P2P でやり取りする前に必要な情報をサーバー経由でやり取りするのだが、これをシグナリングという。

そのためのサーバーをシグナリングサーバー (Signaling Server / Signaler) という。これは必須だ。  
シグナリングの仕組み自体はWebRTCでは特に決められていないらしく、どんな仕組みにするか、どこまでの情報をやり取りするかといったことは実装側に委ねられている。

> 実はシグナリングにはいろいろな仕組みがあるのだが、 WebRTC では定義されていないため、ここでは大まかに定義する。
>
> • 通信しようとする相手の IP アドレスの解決
> 　　• 相手の名前から IP アドレスを取得するなど。つまりこれから通話する相手の IP アドレスを取得することができるようになる仕組み
> • 相手がその通信を許可するかどうか
> 　　• そもそも誰にでも繋がってはいけないので、拒否されているかどうかを判断する仕組み
> • 通信状態（セッションと呼ぶ）において使用するパラメータの合意
> 　　• メディアチャネルであれば、お互いの映像に使うコーデックや最大フレームレートなどの合意をとる仕組み
> • 証明書のフィンガープリント情報の交換
>
> このいくつかの仕組みをまとめてシグナリングと呼ぶことが多い。
>
> (https://gist.github.com/voluntas/67e5a26915751226fdcf より)

#### OSSのシグナリングサーバー

- [WebRTC Signaling Server Ayame](https://github.com/OpenAyame/ayame)
- [PeerServer](https://github.com/peers/peerjs-server) (フロントエンドに [PeerJS](https://github.com/peers/peerjs) を使うことが前提)
- [signalmaster](https://github.com/simplewebrtc/signalmaster) (メンテされてない&#x1f622;)

OSSでなくとも、検索すれば 100行未満のコードで書かれたサンプルがたくさん見つかるだろう。  
単純なもので良ければ自作も容易。

### STUNサーバー

クライアント同士が異なるLANにあるときなど、NATを噛ましている場合には シグナリングサーバーだけでは相手のIPアドレス情報が 十分に分からない。

この場合には加えて STUNサーバーを使う。  
STUN (Session Traversal Utilities for NATs) というのは、NATを透過するためのプロトコルの一つであり、これによってNATがマッピングしたグローバルIPアドレスとポート番号が得られる。  
各クライアントはSTUNサーバーで得られた宛先とP2P通信をする。

ただ、STUNサーバーでもすべての種類のNATを超えられるわけではないらしい。

ちなみにTURNサーバーでどのくらいの環境をカバーできるかというと…

> TURN サーバを建てないと 70% 程度しか繫がらないという調査結果があります。つまり 30% はつながりません。
> (https://gist.github.com/voluntas/379e48807635ed18ebdbcedd5f3beefa より)

だそうだ。

#### OSSのSTUNサーバー

- [Pion STUN](https://github.com/pion/stun)
- TURNサーバーとまとめて提供されることが多いのでTURNサーバーのところでも紹介する

### TURNサーバー

前述のSTUNサーバーを使ってもP2P通信ができないことがある。例えば、Symmetric NAT と呼ばれる種類の NAT を通している場合や、フィイアーウォールを介している場合だ。

これはTURNサーバーを更に導入することで解決できる。  
TURN (Traversal Using Relay around NAT) サーバーがクライアント間の通信をリレーすることでRTCができるようになる。これは Symmentric NAT や ファイアーウォールも超えれる。

クライアント同士でP2P通信をするのではなく、TURNサーバーが通信データをリレーするようになるということは、TURNサーバーの通信量が多くなる。故にTURNサーバーの運用は出費も(ここまでのサーバー構成と比べると)大きくなる。

しかし前述のように70%程度のケースではシグナリングサーバーとSTUNサーバーの構成でP2P通信ができ、TURNサーバーが必要となるのは残りのケースに絞られる。そのケースでだけTURNサーバーを利用するようにすれば、TURNサーバーの負荷ある程度を抑えられる。  
このような仕組みは ICE (Interactive Connectivity Establishment) と呼ばれる。

ちなみに TURNサーバーを設ける場合は通常、それ１台でTURN+STUNサーバーとして動作させることが多い。

また、TURNサーバーは暗号化されたデータをただリレーするだけなので、通信内容は見れない。つまりTURNサーバーでは録音や録画などはできない。

#### OSSのTURNサーバー

次のいずれも、TURNサーバーだけでなく STUNサーバーとしても機能する

- [coturn](https://github.com/coturn/coturn) (ICEもできる)
- [Pion TURN](https://github.com/pion/turn) (ICEするなら [Pion ICE](https://github.com/pion/ice) を使う)
- [aioice](https://github.com/aiortc/aioice) (ICEもできる)
- [Node-turn](https://github.com/Atlantis-Software/node-turn) (ICEもできる)

### SFUサーバー

SFU (Selective Forwarding Unit) サーバー。クライアントが多数あるケースでは SFUサーバーを使うのが良さそう。  
SFUサーバーはクライアントから送られたデータを、宛先となるクライアント(たち)へ配信する。

例えば10人でのRTCをするケースでは、SFUサーバーなしの場合、Aさんからの音声・映像を残りの9人に届けるにはそれぞれ別々の送信がされるされることとなり、クライアントの負荷が高くなる。  
SFUサーバーを用いれば、AさんからはSFUサーバーに送信するだけになり、残りの9人にはSFUサーバーが配信するのでクライアントの負荷を抑えて多人数でのRTCができる。

また、SFUサーバーを介することで、サーバーでの 録音や録画にも対応できるようになる。  
(SFUサーバーに送られる暗号化されたパケットを一旦復号化してから録画・録音し、再び暗号化して配信することで可能)

SFU とよく比較されるものに MCU (Multipoint Control Unit) がある。MCU ではサーバーでクライアントたちの音声・映像を合成した上で配信をするが、この合成にCPUリソースをお消費しすぎる欠点があるようだ。一方SFUではサーバーで合成はせず、それぞれの音声・映像をそれぞれのクライアントへ配信する方式。

#### OSSのSFUサーバー

- [Janus WebRTC Server](https://github.com/meetecho/janus-gateway)
- [mediasoup](https://github.com/versatica/mediasoup)

## 参考になるかもしれないリンク集

今回の調査で参考になった資料、あるいは更に調査したい・実践したい場合に参考にできそうなものをここに書き留める。

### WebRTC を学ぶ上で参考になりそうなページ

- [好奇心旺盛な人のためのWebRTC](https://webrtcforthecurious.com/ja/)
- [WebRTCとのリアルタイム通信](https://codelabs.developers.google.com/codelabs/webrtc-web)
- [WebRTC を今から学ぶ人に向けて](https://zenn.dev/voluntas/scraps/82b9e111f43ab3)
- [WebRTC コトハジメ](https://gist.github.com/voluntas/67e5a26915751226fdcf)
- [仕事で WebRTC](https://gist.github.com/voluntas/379e48807635ed18ebdbcedd5f3beefa)
- [webrtc.org](https://webrtc.org/)
- [WebRTC API | MDN Web Docs](https://developer.mozilla.org/ja/docs/Web/API/WebRTC_API)

### サンプルとして参考になりそうなページ（フロントエンド・バックエンド問わず）

- [WebRTCとのリアルタイム通信](https://codelabs.developers.google.com/codelabs/webrtc-web) (再掲)
- [WebRTC samples | webrtc.org](https://webrtc.github.io/samples/)
- [coTurnでEC2上にTURNサーバを作ってみた](https://qiita.com/okyk/items/2d7db6b148a43bc3b405)

### 商用サービス・製品

自分で構築・運用する以外にも、お金を払って商用のものを利用する選択肢だってある。

- [SkyWay](https://webrtc.ecl.ntt.com/)
- [WebRTC SFU Sora](https://sora.shiguredo.jp/)
- [SimpleWebRTC](https://www.simplewebrtc.com/)
- [agora](https://www.agora.io/en/)
- [Twilio](https://www.twilio.com/ja/)
- [Sendbird](https://sendbird.com/)
- [マルキャス](https://marucast.jp/)
- [Amazon Chime](https://aws.amazon.com/jp/chime/)
- [Vonage](https://www.vonagebusiness.jp/)
