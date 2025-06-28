---
title: "[Xcode] Printer Simulator を導入して プリンターの実機なしで印刷機能を開発する"
# image: "/images/tech-blog/slug/image.jpg"
description: "Xcode の Printer Simulator を使って、実機のプリンターがなくても印刷機能を開発する方法を紹介する。"
published: "2018-09-23"
updated: "2025-06-28"
category: "tech"
tags: ["ios", "swift", "xcode", "printing"]
---

印刷などの機能を開発したいが、そもそもプリンターを持っていない。  
詰んだか？

いや、問題ない。  
プリンターのシミュレーターを Apple が提供しているので、それを利用すれば実物のプリンターを持っていなくとも、印刷機能などの開発ができる。

## 準備

### 1. Additional Tools を入手する

以下の記事を参考にして`Additional_Tools_for_Xcode_9.3.dmg`を入手する。  
**※バージョンは自分の Xcode のバージョン以下のものの中から最新を選ぶこと**  
**※筆者の環境は Xcode 9.4.1**

[Apple の開発者向けツールや 旧版 / β版 の Xcode / OS / SDK などをダウンロードする方法](https://hahnah.github.io/tech-blog/2018-apple-download-more/)

### 2. Printer Simulator.app を Xcode から使用可能にする

入手した dmg を開くと`Hardware`というフォルダがあり、その中に`Printer Simulator.app`があることが分かる。

![additional-tools-dmg](/images/tech-blog/2018-xcode-printer-simulator/printer-simulator-app-in-dmg.avif)

この`Printer Simulator.app`を`/Applications/Xcode.app/Contents/Applications/`へコピー&ペーストする。  
**※ Xcode.app を右クリックで [パッケージの内容を表示] とすると Contents が見れる**

## Xcode から Printer Simulator.app を起動する

準備が終わったので、実際に使ってみる。

[Xcode] > [Open Developer Tool] > [Printer Simulator] を選択して Printer Simulator を起動する。

![open-printer-simulator](/images/tech-blog/2018-xcode-printer-simulator/open-printer-simulator.avif)

この状態で Xcode プロジェクトを Run するとプリンターを扱う際に Printer Simulator が使われ、実機のプリンターがなくとも印刷などの動作確認ができるというわけだ。

## 参考

- [Apple の開発者向けツールや 旧版/β版 の Xcode/OS/SDK などをダウンロードする方法](https://hahnah.github.io/tech-blog/2018-apple-download-more/)
- [[Swift]UIPrinterPickerControllerを使ってAirPrint印刷する方法 | Qiita](https://qiita.com/SatoTakeshiX/items/264dd293efeae2fdef11)
