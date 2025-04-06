---
title: "[Swift] FlexibleAVCapture で 縦長/横長/正方形 など自由なサイズの動画を撮影する"
# image: "/images/tech-blog/slug/image.jpg"
description: "iPhoneで好きな形状の動画を撮影するためのライブラリ FlexibleAVCapture を作成した"
published: "2019-03-16"
updated: "2025-04-06"
category: "tech"
tags:
  [
    "hahnah's-library",
    "swift",
    "ios",
    "flexible-av-capture",
    "video",
    "flex-camera",
  ]
---

**iPhoneで好きな形の動画が撮れたら面白いのにな**

ある時そう思ったので、その機能を提供するライブラリを作った。

![screencapture](/images/tech-blog/2019-swift-flexible-av-capture/screencapture.gif)

今回紹介する`FlexibleAVCapture`を使えば、こんな風な長方形の動画を撮影することができる。  
(スクリーンキャプチャは、撮影する動画の形を設定しているシーン)

## その名は FlexibleAVCapture

`FlexibleAVCapture`は CocoaPodsで提供するiOSアプリ開発用のライブラリだ。

フレキシブルな動画を撮影するために以下のものを提供している:

- 動画撮影のためのセッション管理
- カメラのプレビュー画面
- 動画撮影の設定UI
  - デフォルトのボタンやスライダーがセットされている
  - 好みのUIに置き換えることも可能
- ズームやフォーカスの機能
  - ピンチイン/ピンチアウトのジェスチャーでズームが働く
  - タップした箇所にあわせてフォーカスと露光を調整する
- その他動画撮影に関する設定を行うためのAPI

デフォルトの設定が用意されているので、ほとんどコードを書くことなく利用することもできる。

CocoaPods と GitHub にてソースコードを公開している。

CocoaPods:  
[https://cocoapods.org/pods/FlexibleAVCapture](https://cocoapods.org/pods/FlexibleAVCapture)

GitHub:  
[https://github.com/hahnah/FlexibleAVCapture](https://github.com/hahnah/FlexibleAVCapture)

## FlexibleAVCaptureの導入・利用

FlexibleAVCaptureを使って本記事冒頭のスクリーンキャプチャにあるようなものを実装する方法を紹介していく。

### 利用するための前提条件

- iOS 11.0 以降をターゲットとしていること
- CocoaPods をプロジェクトに導入していること

### インストール

1. あなたのプロジェクトの`Podfile`に以下の行を追記する

```
pod 'FlexibleAVCapture'
```

2. `pod install`とコマンドを打つとインストールが始まる

### FlexibleAVCaptureを使ってみる

あなたのViewCotrollerにおいて

```
import FlexibleAVCapture
```

とすることで、`FlexibleAVCaptureViewController`,`FlexibleAVCaptureDelegate`が利用できるようになる。これらについて以下のことを行えば良い。

- ViewController に`FlexibleAVCaptureDelegate`プロトコルを継承させ、`didCapture(withFileURL fileURL: URL)`メソッドに動画撮影後の処理（フォトライブラリに保存するなど）を実装する
- `FlexibleAVCaptureViewController`インスタンスを作成し、`delegate`を設定する

例えば次のように実装する。

```swift
import UIKit
import FlexibleAVCapture

class ViewController: UIViewController, FlexibleAVCaptureDelegate {

    let flexibleAVCaptureVC: FlexibleAVCaptureViewController = FlexibleAVCaptureViewController()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.flexibleAVCaptureVC.delegate = self
        self.present(flexibleAVCaptureVC, animated: true, completion: nil)
    }

    func didCapture(withFileURL fileURL: URL) {
        print(fileURL)
    }

}
```

上記実装例では、記事冒頭のスクリーンキャプチャにあるような画面が表示され、録画が完了すると録画ファイルの(テンポラリーな)URLをログに出力する。

わずかな実装で FlexibleAVCapture を利用できることが分かるだろう。

### 詳細な設定

さまざまな詳細設定をするためのAPIも提供している。例えば:

- フロントカメラ/バックカメラのどちらを使うかの設定
- 録画画質の設定
- 録画の上限時間の設定
- デフォルトのUI(ボタン/スライダー)を別のボタン/スライダーで置き換える
- 録画開始/終了時に音を鳴らすかどうかの設定

詳しくはAPIリファレンスを参照:  
[https://cocoapods.org/pods/FlexibleAVCapture#api](https://cocoapods.org/pods/FlexibleAVCapture#api)

## ダウンロードして試せるアプリ例: Flex Camera

FlexibleAVCaptureを使って簡単な iOSアプリ を作成し、AppStoreにリリースしている。  
どんなものが作れるのか、参考として触ってみるのも良いだろう。

Flex Camera アプリはこちらの紹介記事はこちら:  
[https://hahnah.github.io/tech-blog/2019-flex-camera/](https://hahnah.github.io/tech-blog/2019-flex-camera/)

アプリダウンロードURL:  
~~https://itunes.apple.com/us/app/flex-camera/id1455345286~~  
※ 2025年現在、このアプリは利用できません。

このアプリはソースコードも公開しているので、実装方法の参考にもなれば幸いだ。  
[https://github.com/hahnah/FlexCamera](https://github.com/hahnah/FlexCamera)
