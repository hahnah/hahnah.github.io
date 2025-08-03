---
title: "[Swift] 画像からサムネイルを作成する"
# image: "/images/tech-blog/slug/image.jpg"
description: "Swiftで画像から正方形のサムネイルを生成する方法を紹介する。"
published: "2018-08-13"
updated: "2025-08-03"
category: "tech"
tags: ["swift", "image-processing"]
---

手順は次の通り。

![サムネイル生成方法](/images/tech-blog/2018-swift-thumbnail-generator/generate-thumnail.avif)

1. 画像をリサイズする
   1-1. リサイズの目標サイズを計算する
   1-2. 目標サイズへリサイズした画像を生成する
2. リサイズ画像をクロッピングする
   2-1. サムネイルの目標サイズに合わせて、クロッピングする形を計算する
   2-2. リサイズ画像をクロッピングしてサムネイルを作成する

最終的なコード全体は最下部

[GitHub](https://github.com/hahnah/ThumbnailGenerator) で見るにはこちら。

## 1. 画像をリサイズする

### 1-1. リサイズの目標サイズを計算する

```swift
func calculateResizedWidth(sourceImage: UIImage, objectiveLengthOfShortSide: CGFloat) -> CGFloat {
        let width: CGFloat = sourceImage.size.width
        let height: CGFloat = sourceImage.size.height
        let resizedWidth: CGFloat = width <= height ? objectiveLengthOfShortSide : objectiveLengthOfShortSide * width / height
        return resizedWidth
}
```

上記の`calculateResizedWidth`関数を用いて、リサイズ後画像の幅をいくらにすべきかを計算する。

次の変数があるとして、

```swift
let sourceImage: UIImage = もともとのUIImage
let objectiveEdgeLength: CGFloat = サムネイルの一辺の長さとしたい値（サムネイルは正方形と仮定しています）
```

次のコードでリサイズ後画像の幅`resizedWidth`が得られる。

```swift
let resizedWidth: CGFloat = calculateResizedWidth(sourceImage: sourceImage, objectiveLengthOfShortSide: objectiveEdgeLength)
```

### 1-2. 目標サイズへリサイズした画像を生成する

```swift
func resizeImage(sourceImage: UIImage, objectiveWidth: CGFloat) -> UIImage {
        let aspectScale: CGFloat = sourceImage.size.height / sourceImage.size.width
        let resizedSize: CGSize = CGSize(width: objectiveWidth, height: objectiveWidth * aspectScale)

        // リサイズ後のUIImageを生成して返却
        UIGraphicsBeginImageContext(resizedSize)
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage!
}
```

上記の`resizeImage`関数に、1-1 で得た`resizedWidth`を引数として渡してやることでリサイズされた画像が得られる。

```swift
 let resizedImage: UIImage = resizeImage(sourceImage: sourceImage, objectiveWidth: resizedWidth)
        let thumbnailSize: CGSize = CGSize(width: objectiveEdgeLength, height: objectiveEdgeLength)
```

## 2. リサイズ画像をクロッピングする

### 2-1. サムネイルの目標サイズに合わせて、クロッピングする形を計算する

```swift
func calulateCroppingRect(imgae: UIImage, objectiveSize: CGSize) -> CGRect {
        let croppingRect: CGRect = CGRect.init(x: (imgae.size.width - objectiveSize.width) / 2, y: (imgae.size.height - objectiveSize.height) / 2, width: objectiveSize.width, height: objectiveSize.height)
        return croppingRect
}
```

1-2 で得た`resizedImage`と上記の`calulateCroppingRect`を用いて、クロッピングする形を計算する。

```swift
let thumbnailSize: CGSize = CGSize(width: objectiveEdgeLength, height: objectiveEdgeLength)
let croppingRect: CGRect = calulateCroppingRect(imgae: resizedImage, objectiveSize: thumbnailSize)
```

### 2-2. リサイズ画像をクロッピングしてサムネイルを作成する

```swift
func cropImage(image: UIImage, croppingRect: CGRect) -> UIImage {
        let croppingRef: CGImage? = image.cgImage!.cropping(to: croppingRect)
        let croppedImage: UIImage = UIImage(cgImage: croppingRef!)
        return croppedImage
}
```

1-2 で得た`resizedImage`と 2-1 で得た`croppingRect`を上記の`cropImage`関数に渡してやることで、サムネイルを得る。

```swift
let croppedImage: UIImage = cropImage(image: resizedImage, croppingRect: croppingRect)
```

## コード全体

`generateThumbnail`関数を呼び出してやれば、サムネイルが返ってくる。

```swift
func generateThumbnail(sourceImage: UIImage, objectiveEdgeLength: CGFloat) -> UIImage {
        let resizedWidth: CGFloat = calculateResizedWidth(sourceImage: sourceImage, objectiveLengthOfShortSide: objectiveEdgeLength)
        let resizedImage: UIImage = resizeImage(sourceImage: sourceImage, objectiveWidth: resizedWidth)
        let thumbnailSize: CGSize = CGSize(width: objectiveEdgeLength, height: objectiveEdgeLength)
        let croppingRect: CGRect = calulateCroppingRect(imgae: resizedImage, objectiveSize: thumbnailSize)
        let croppedImage: UIImage = cropImage(image: resizedImage, croppingRect: croppingRect)
        return croppedImage
}

func calculateResizedWidth(sourceImage: UIImage, objectiveLengthOfShortSide: CGFloat) -> CGFloat {
        let width: CGFloat = sourceImage.size.width
        let height: CGFloat = sourceImage.size.height
        let resizedWidth: CGFloat = width <= height ? objectiveLengthOfShortSide : objectiveLengthOfShortSide * width / height
        return resizedWidth
}

func resizeImage(sourceImage: UIImage, objectiveWidth: CGFloat) -> UIImage {
        let aspectScale: CGFloat = sourceImage.size.height / sourceImage.size.width
        let resizedSize: CGSize = CGSize(width: objectiveWidth, height: objectiveWidth * aspectScale)

        // リサイズ後のUIImageを生成して返却
        UIGraphicsBeginImageContext(resizedSize)
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage!
}

func calulateCroppingRect(imgae: UIImage, objectiveSize: CGSize) -> CGRect {
        let croppingRect: CGRect = CGRect.init(x: (imgae.size.width - objectiveSize.width) / 2, y: (imgae.size.height - objectiveSize.height) / 2, width: objectiveSize.width, height: objectiveSize.height)
        return croppingRect
}

func cropImage(image: UIImage, croppingRect: CGRect) -> UIImage {
        let croppingRef: CGImage? = image.cgImage!.cropping(to: croppingRect)
        let croppedImage: UIImage = UIImage(cgImage: croppingRef!)
        return croppedImage
}
```

[GitHub はこちら。](https://github.com/hahnah/ThumbnailGenerator)
