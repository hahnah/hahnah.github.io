---
title: "[Swift] いとも簡単にトーストを表示する (HNToaster)"
# image: "/images/tech-blog/slug/image.jpg"
description: "iOSでトーストを表示するためのライブラリHNToasterを紹介する。たった１行のコードでトーストが表示できる。"
published: "2018-09-30"
updated: "2025-06-27"
category: "tech"
tags: ["swift", "toast"]
---

iOS で Toast を表示するためのライブラリをリリースしたので、紹介する。

このライブラリ`HNToaster`を使うと、  
次の **たった１行のコード** を書くだけでトーストが表示できる。

```swift
Toaster.toast(onView: self.view, message: "Can you see me?")
```

![screenshot1](/images/tech-blog/2018-swift-hntoaster/hntoaster.gif)

さらに、パラメーターを与えれば次のような指定もできる。

- トーストの表示領域の指定(場所、大きさ)
- トーストに表示する文字のフォント指定(種類、サイズ)

## 目次

- HNToaster のインストール方法
  1. CoacoaPods をインストールする
  2. Xcode のプロジェクトで CocoaPods を使えるようにする
  3. HNToaster を CocoaPods でインストールする
  4. (もしくは CocoaPods を使わない方法)
- HNToaster を使ってみる
  - 最も簡単な使い方
  - 表示領域とフォントを指定する使い方
  - Example&nbsp;Project

## HNToaster&nbsp;のインストール方法

### 1.&nbsp;CocoaPods&nbsp;をインストールする

まず、 RubyGem の最新化、 CocoaPods インストールとセット・アップ をする。

```
$ sudo gem update --system
$ sudo gem install cocoapods
$ pod setup
```

### 2.&nbsp;Xcode&nbsp;のプロジェクトで&nbsp;CocoaPosd&nbsp;を使えるようにする

プロジェクトのあるディレクトリに`Podfile`というファイルを作成する。

```
$ cd ~/YourProject/
$ vim Podfile
```

**Podfile**

```
platform :ios, "8.0"
pod 'HNToaster', '~> 1.0'
```

※&uarr;の`Podfile`では iOS 8.0以上、HNToaster 1.X を指定している

### 3.&nbsp;HNToaster&nbsp;を&nbsp;CocoaPods&nbsp;でインストールする

```
$ pod install
```

これで HNToaster がインストールできた。

`YourProject.xcworkspace`を Xcode で開くことで、自分のプロジェクトと CocoaPods のライブラリ をリンクさせてビルドができる。  
(YourProject.codeproj ではなく **.xcworkspace** の方を開く)

### 4.&nbsp;(もしくは&nbsp;CocoaPods&nbsp;を使わない方法)

ここまでで HNToaster をインストールしたという方はこの項目を飛ばしてOK。  
「CocoaPodsを使わない」という方のみを対象としている。

&darr;のファイルをプロジェクトにコピーすることで、`HNToaster.swift`を入手しても良い。  
[https://github.com/hahnah/HNToaster/blob/1.0.0/HNToaster/Classes/HNToaster.swift](https://github.com/hahnah/HNToaster/blob/1.0.0/HNToaster/Classes/HNToaster.swift)

## HNToaster&nbsp;を使ってみる

まず、適当な swift ファイルに HNToaster を import しよう。  
※ 4.&nbsp;(もしくは&nbsp;CocoaPods&nbsp;を使わない方法) の場合は import 不要

```swift
import HNToaster
```

### 最も簡単な使い方

`Toaster.toast(onView: UIView message: String)`のメソッドを呼び出せばトーストが表示される。  
引数`onView`には トーストを浮かび上がらせたいビュー を、`message`には表示したい文字列を渡す。

&darr;のコードでは、記事冒頭のアニメーションで見せたトーストが表示される。

```swfit
let message1: String = "Can you see me?"
Toaster.toast(onView: self.view, message: message1)
```

### 表示領域とフォントを指定する使い方

`Toaster.toast(onView: UIView, message: String, frame: CGRect?, font: UIFont?)`のメソッドを使えば、トーストの表示領域やフォントの指定も可能だ。

引数`frame`にはトーストの表示領域となる CGRect インスタンスを、`font`には UIFont インスタンスを渡すことで、トーストの表示位置や縦x横の大きさ、フォントの種類やサイズを 指定することができる。  
**※引数を nil にした場合はデフォルト値が適用される**

```swift
let message2: String = """
You can arrange
the toast's frame
and the message's font.
"""

let toastFrame: CGRect = CGRect(x: 10, y: self.view.bounds.height - 150, width: self.view.bounds.width - 20, height: 120)

let messageFont: UIFont = UIFont.italicSystemFont(ofSize: 32)

Toaster.toast(onView: self.view, message: message2, frame: toastFrame, font: messageFont)
```

### Example&nbsp;Project

Example ディレクトリにサンプルを置いてあるのでそれを試せる。

もしくはまだ HNToaster をインストールしていない場合でも、  
以下のコマンドを打つと自動的にリポジトリを clone して Example Project を Xcode で開くので、あとは Xcode の Run ボタンを押すと簡単にサンプルを実行できる。 (CocoaPodsすごい!)

```
$ pod try HNToaster
```

![screenshot2](/images/tech-blog/2018-swift-hntoaster/screenshot.avif)
