---
title: "[Swift] 動画から静止画像を取り出す"
# image: "/images/tech-blog/slug/image.jpg"
description: "動画中の指定した秒数の部分を静止画像として取り出す方法について調べたので紹介する。"
published: "2018-08-08"
updated: "2025-08-03"
category: "tech"
tags: ["swift", "image"]
---

また、記事の後半では、[0,1]の範囲で指定した位置を静止画として取り出す方法についても触れる。

## 秒数指定で静止画を取り出す方法

始めに結論を述べると、例えば以下コードでは動画の 10 秒目を取り出した`image`が得られる。

```swift
let capturingTimeWithSeconds: Float64 = Float64(10)
let capturingTime: CMTime = CMTimeMakeWithSeconds(capturingTimeWithSeconds, 1)
let image: CGImage = captureImage(movieURL: yourMovieURL, capturingTime: capturingTime)
```

ここで、 `captureImage`関数は以下のものであり、また`yourMovieURL`はあなたが対象としたい動画のURLであるとする。

```swift
func captureImage(movieURL: URL, capturingTime: CMTime) -> CGImage? {
	let asset: AVAsset = AVURLAsset(url: movieURL, options: nil)
	let imageGenerator: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
	do {
		let cgImage: CGImage = try imageGenerator.copyCGImage(at: capturingTime, actualTime: nil)
		return cgImage
	} catch {
		return nil
	}
}
```

### 解説

動画から静止画を取り出すには、`AVAssetImageGenerator.copyCGImage`関数を用いる。

この関数のインターフェースを確認すると次の様になっている。

```swift
func copyCGImage(at requestedTime: CMTime, actualTime: UnsafeMutablePointer<CMTime>?) throws -> CGImage
```

引数`at`には、`CMTime`のオブジェクトを渡す必要があると分かる。

例えば次のようにすると、10秒目を指定する`CMTime`のオブジェクトが作られる。

```swift
let capturingTime: CMTime = CMTimeMakeWithSeconds(Float64(10), 1)
```

ちなみに、第２引数を変えて、以下のようにした場合では、

```swift
let capturingTime: CMTime = CMTimeMakeWithSeconds(Float64(10), 60)
```

600秒目を指定する `CMTime` のオブジェクトが作られる。（10分ってこと）
つまり、第１引数 × 第２引数 秒目が指定されるということのようだ。

こうやって作成した`CMTime`のオブジェクトを`AVAssetImageGenerator.copyCGImage`の引数`at`として渡してやれば、その秒数の箇所の`CGImage`オブジェクトが得られる。

```swift
let cgImage: CGImage = try imageGenerator.copyCGImage(at: capturingTime, actualTime: nil)
```

ここで、第２引数`actualTime`には何をどう設定できるのか私がよく知らないのだが、  
[公式ドキュメント](https://developer.apple.com/documentation/avfoundation/avassetimagegenerator/1387303-copycgimage) を見た感じでは、大体の場合では`nil`で良さそうな雰囲気？

> actualTime
> Upon return, contains the time at which the image was actually generated.
> If you are not interested in this information, pass NULL.

## 取り出す位置を [0,1] 閉区間上で指定する場合

[0,1] 閉区間上の値で取り出し位置を指定したいケースがありそうなので、それについても触れておこうと思う。  
例えば、スライダーなどで指定した箇所を静止画として得たいという場合などが該当する。

動画の始まりを`0`、終わりを`1`とて表したば場合、  
「動画の丁度半分の位置にあたるフレームを取り出す」ということがしたいのであれば、それはつまり  
「動画の0.5の位置を取り出す」ということになる。

次のコードでは、`yourMovieURL`の動画から、0.5 の位置を静止画`image`として得る。

```swift
let capturingPoint: Float64 = 0.5 // capturingPoint ∈ [0,1]
let capturingTime: CMTime = generateCMTime(movieURL: yourMovieURL, capturingPoint: capturingPoint)
let image: CGImage = captureImage(movieURL: yourMovieURL, capturingTime: capturingTime)
```

ここで、 `generateCMTime`は次の関数であり、  
`capturiingPoint`([0,1]閉区間上)を指定する`CMTime`オブジェクトを返す。

```swift
func generateCMTime(movieURL: URL, capturingPoint: Float64) -> CMTime {
	let asset = AVURLAsset(url: movieURL, options: nil)
	let lastFrameSeconds: Float64 = CMTimeGetSeconds(asset.duration)
	let capturingTime: CMTime = CMTimeMakeWithSeconds(lastFrameSeconds * capturingPoint, 1)
	return capturingTime
}
```

`captureImage`関数は再掲になるが、以下のとおり。

```swift
func captureImage(movieURL: URL, capturingTime: CMTime) -> CGImage? {
	let asset: AVAsset = AVURLAsset(url: movieURL, options: nil)
	let imageGenerator: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
	do {
		let cgImage: CGImage = try imageGenerator.copyCGImage(at: capturingTime, actualTime: nil)
		return cgImage
	} catch {
		return nil
	}
}
```

### 参考サイト

- [[Swift]CMTimeを使う | nackpan Blog](https://nackpan.net/blog/2015/10/15/swift-cmtime/)
- [005 動画から静止画を取り出す | Swift Docs](http://docs.fabo.io/swift/avfoundation/005_avfoundation.html)
