---
title: "[Swift] ツマミが2つのスライダーを利用する (WARangeSlider)"
# image: "/images/tech-blog/slug/image.jpg"
description: "Swiftでツマミが2つのスライダーを実装する方法を紹介する。WARangeSliderライブラリを使い、動画トリミングなどの用途に役立つRange Sliderの使い方と拡張方法を解説。"
published: "2018-09-01"
updated: "2025-07-15"
category: "tech"
tags: ["ios", "swift"]
---

## 概要

ツマミが１つのスライダーとしては 標準の UISlider があり、定められた範囲から値を一つ選択するのに利用できる。

スライダーのツマミが２つになると何ができるようになるかというと、定められた範囲内の、任意の範囲を取得/選択できるようになる。  
もしくは、定められた範囲内で、小さい方の値と大きい方の値の２つの値を取得/選択できるということでもある。

![demo](/images/tech-blog/2018-swift-range-slider/demo.webp)

これは、例えば動画をトリミングする範囲をユーザーに選択させる場合に役立つ。  
（ただ、動画をトリミングする用途であれば UIVideoEditorController を使ったほうがよいと思うが、他にも Range Slider が役立つ用途があることは分かって頂けるだろう）

このような Range Slider が既に OSS ([WARangeSlider](https://github.com/warchimede/RangeSlider)) としてあるので、  
それの使い方と、私なりのちょっとした拡張を紹介する。

ちなみに、紹介する内容を含むサンプルプロジェクトを[GitHub](https://github.com/hahnah/til-swift/tree/master/RangeSlider) に置いてある。

## インストール

CocoaPods で WARangeSlider を XCode プロジェクトにインストールする。

Podflie に以下の行を加え、

```
pod "WARangeSlider"
```

それからターミナルでコマンド実行してインストールする。

```
$ pod install
```

## 実装

利用するファイルで import の記述が必要。

```swift
import WARangeSlider
```

次のようにしてRangeSlider オブジェクトを利用する。

```swift
let rangeSlider: RangeSlider = RangeSlider(frame: yourFrame)
view.addSubview(rangeSlider)
rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)
```

RangeSlider のどちらかのツマミが動くたびに、`rangeSliderValueChanged(_:)`メソッドが呼び出されるので、実行させたいことをそこに書くといいだろう。

```swift
@objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) -> Void {
	print(rangeSlider.lowerValue)
	print(rangeSlider.upperValue)
}
```

## プロパティ一覧

RangeSlider オブジェクトの以下のプロパティを利用することで、情報の参照や RangeSlider オブジェクトのカスタマイズができる。

| プロパティ                | 概要                                   |
| ------------------------- | -------------------------------------- |
| `minimumValue`            | スライダー範囲の下限値                 |
| `maximumValue`            | スライダー範囲の上限値                 |
| `lowerValue`              | 左ツマミの現在の値                     |
| `upperValue`              | 右ツマミの現在の値                     |
| `trackTintColor`          | ツマミの外側のトラックの色             |
| `trackHighlightTintColor` | ツマミの間のトラックの色               |
| `thumbTintColor`          | ツマミの色                             |
| `thumbBorderColor`        | ツマミの枠の色                         |
| `thumbBorderWidth`        | ツマミの枠の太さ                       |
| `curvaceousness`          | ツマミの丸み具合 (四角:0 <-----> 1:丸) |

## 拡張 - 変化した方の値を参照する

記事執筆時点の [WARangeSlider (ver. 1.1.1)](https://github.com/warchimede/RangeSlider/tree/1.1.1) では、スライダーのツマミが移動したときに、左右どちらが移動したのかまでは教えてくれない。

「動いた方のツマミの情報が欲しいんだ」

といケースは多々あると思うので、拡張しておく。

`changedValue`プロパティを参照すれば動いた方のツマミの値が得られるようになっている。

```swift
import WARangeSlider

var _previousLowerValue: Double = 0
var _previousUpperValue: Double = 0
var _changedValue: Double? = nil

extension RangeSlider {
    var previousLowerValue: Double {
        get {
            return (objc_getAssociatedObject(self, &_previousLowerValue) ?? 0) as! Double
        }
        set {
            objc_setAssociatedObject(self, &_previousLowerValue, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    var previousUpperValue: Double {
        get {
            return (objc_getAssociatedObject(self, &_previousUpperValue) ?? 0) as! Double
        }
        set {
            objc_setAssociatedObject(self, &_previousUpperValue, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    var lowerValueChanged: Bool {
        get {
            return self.previousLowerValue != self.lowerValue
        }
    }

    var upperValueChanged: Bool {
        get {
            return self.previousUpperValue != self.upperValue
        }
    }

    var changedValue: Double? {
        get {
            if self.lowerValueChanged {
                objc_setAssociatedObject(self, &_changedValue, self.lowerValue, .OBJC_ASSOCIATION_RETAIN)
                return self.lowerValue
            } else if self.upperValueChanged {
                objc_setAssociatedObject(self, &_changedValue, self.upperValue, .OBJC_ASSOCIATION_RETAIN)
                return self.upperValue
            } else {
                return (objc_getAssociatedObject(self, &_changedValue)) as! Double?
            }
        }
    }

    func updatePreviousValues() -> Void {
        self.previousLowerValue = self.lowerValue
        self.previousUpperValue = self.upperValue
    }
}
```

#### 利用時の注意

`updatePreviousValues()`メソッドを次のタイミングで良い出すことを守って頂きたい。

- RangeSlider オブジェクトの初期化後
- rangeSliderValueChanged(\_:) メソッド内の最終行

そうすることで`changedValue`が正しく得られるようになる。

```swift
let rangeSlider: RangeSlider = RangeSlider(frame: yourFrame)

override func viewDidLoad() {
	// RangeSlider オブジェクトの初期化後に呼び出すこと
	self.rangeSlider.updatePreviousValues()

	view.addSubview(rangeSlider)
	rangeSlider.addTarget(self, action: #selector(ViewController.rangeSliderValueChanged(_:)),
                              for: .valueChanged)
}

@objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) -> Void {
	if let value = rangeSlider.changedValue {
		// CODE
		print(value)
	}
	// rangeSliderValueChanged(_:) メソッド内の最終行で呼び出すこと
	rangeSlider.updatePreviousValues()
}
```

## GitHub

より詳細で具体的なサンプルコードは [GitHub](https://github.com/hahnah/til-swift/tree/master/RangeSlider) にある。  
冒頭のイメージと全く同じものはそちらを clone して試せる。
