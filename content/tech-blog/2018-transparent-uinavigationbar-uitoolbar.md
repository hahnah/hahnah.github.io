---
title: "[Swift] UINavigationBar, UIToolbar を透明にする"
# image: "/images/tech-blog/slug/image.jpg"
description: "iOS アプリでカメラ映像を全画面表示するための UINavigationBar と UIToolbar の透明化方法"
published: "2018-08-07"
updated: "2025-08-03"
category: "tech"
tags: ["swift"]
---

カメラを使った iOS アプリにおいて、ツールバーやナビゲーションバーを表示したいときは、 バーの背景色を透明にするのがはおすすめだ。

その理由として、  
バーを透明にすると、バーの領域にもカメラ映像が表示され、画面一杯に映し出すことができるから  
というのが挙げられる。

特に AR 関連のアプリにおいては、 これは重要である。

ユーザーと AR 世界のインターフェイスとなる画面領域を狭めてしまうような UI を配置してしまうと、UX が大きく低下してしまうため、そうなることは避けたい。

## UINavigationBar の背景を透明にする

以下のコードでは`UINavigationBar.xxx`という書き方をしているが、背景を透明にしたい UINavigationBar オブジェクトに適宜置き換えて利用していただきたい。

```swift
UINavigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
UINavigationBar.setBackgroundImage(UIImage(), for: .default)
UINavigationBar.shadowImage = UIImage()
```

ちなみに上記１行目で NavigationBar のタイトル文字色を白にしているが、これは利用が想定される環境で文字が見えるような色であれば何でも良い。

## UIToolbar の背景を透明にする

```swift
UIToolbar.tintColor = UIColor.white
UIToolbar.isTranslucent = true
UIToolbar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.any, barMetrics: UIBarMetrics.default)
UIToolbar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any)
```
