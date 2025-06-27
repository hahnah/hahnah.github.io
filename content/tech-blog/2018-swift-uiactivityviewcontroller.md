---
title: "[Swift] UIActivityViewController を使って Facebook/Twitter でシェアしたりカメラロールに保存したりする方法"
# image: "/images/tech-blog/slug/image.jpg"
description: "iOSでよくある Activity のシェア機能を実装する方法を紹介する。UIActivityViewControllerを使うと簡単に実装できる。"
published: "2018-09-29"
updated: "2025-06-27"
category: "tech"
tags: ["ios", "swift"]
---

![ios-activity-button](/images/tech-blog/2018-swift-uiactivityviewcontroller/ios-activity-button.avif)

&uarr; のボタンを押すと Facebook 投稿や画像保存など、 Activity の候補が出てきて、その中から選んで実行できるという、

よくあるこの機能を実装する方法を紹介する。

![uiactivity-description-image](/images/tech-blog/2018-swift-uiactivityviewcontroller/uiactivity-description-image.avif)

## 実装

`activityButton`をツールバー上に設置し、これがタップされると`showActivityView(_ sender: `メソッドを呼び出して UIActivityView に画面遷移するように実装した。

([GitHub](https://github.com/hahnah/til-swift/tree/master/UIActivity)にもソースあり)

**ViewController.swift**

```swift
import UIKit

class ViewController: UIViewController {

    var printingImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // image
        self.printingImage = UIImage(named: "sampleImage.png")
        let imageView: UIImageView = UIImageView(image: self.printingImage)
        let imageAspect: CGFloat = (self.printingImage?.size.height)! / (self.printingImage?.size.width)!
        imageView.frame = CGRect(x: self.view.bounds.width * 0.05, y: self.view.bounds.height * 0.1, width: self.view.bounds.width * 0.9, height: self.view.bounds.width * 0.9 * imageAspect)
        self.view.addSubview(imageView)

        // toolbar
        self.view.isOpaque = false
        let toolbarHeight: CGFloat = 80
        let toolbarPaddingBottom: CGFloat = 20
        let toolbarRect: CGRect = CGRect(x: 0, y: self.view.bounds.height - toolbarHeight - toolbarPaddingBottom, width: self.view.bounds.width, height: toolbarHeight)
        let toolbar: UIToolbar = UIToolbar(frame: toolbarRect)
        let activityButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.showActivityView(_:)))
        let buttonGap: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.items = [buttonGap, activityButton, buttonGap]
        self.view.addSubview(toolbar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func showActivityView(_ sender: UIBarButtonItem) -> Void {
        let activityItems: Array<Any> = [self.printingImage!]

        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        let excludedActivityTypes: Array<UIActivityType> = [
            // UIActivityType.addToReadingList,
            // UIActivityType.airDrop,
            // UIActivityType.assignToContact,
            // UIActivityType.copyToPasteboard,
            // UIActivityType.mail,
            // UIActivityType.message,
            // UIActivityType.openInIBooks,
            // UIActivityType.postToFacebook,
            UIActivityType.postToFlickr,
            UIActivityType.postToTencentWeibo
            // UIActivityType.postToTwitter,
            // UIActivityType.postToVimeo,
            // UIActivityType.postToWeibo,
            // UIActivityType.print,
            // UIActivityType.saveToCameraRoll,
            // UIActivityType.markupAsPDF
        ]
        activityViewController.excludedActivityTypes = excludedActivityTypes

        activityViewController.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, activityError: Error?) in

            guard completed else { return }

            switch activityType {
            case UIActivityType.postToTwitter:
                print("Tweeted")
            case UIActivityType.print:
                print("Printed")
            case UIActivityType.saveToCameraRoll:
                print("Saved to Camera Roll")
            default:
                print("Done")
            }
        }

        self.present(activityViewController, animated: true, completion: nil)
    }

}
```

`UIActivityViewController`を扱う際に抑えたいポイントは主に3つだ。

### ポイント1

**`activityItems`に、投稿/保存などしたいものを指定してイニシャライズすること。**  
`UIActivityViewController(activityItems:applicationActivities:)`

ちなみに、異なるクラスのインスタンスが混ざっていてもよく、例えば次のようなものをよく使うことになるだろう。

- UIImage (画像)
- URL (URL)
- String (テキスト)

念の為補足すると、画像をアルバムに保存するような Activity がなされる場合には  
**Privacy - Photo Library Additions Usage Description**  
を info.plist に記述することが必要。

### ポイント2

**`excludedActivityTypes`プロパティで、除外したい AcivityType を指定すること。**

例えば Flickr と Tencent Weibo ではシェアしないという想定なのであれば、次のように書く。

```swift
activityViewController.excludedActivityTypes = [
    UIActivityType.postToFlickr,
    UIActivityType.postToTencentWeibo
]
```

除外するものを指定するわけなので、**この設定は必須でない**。  
設定しなければ、単にすべてが選択肢になるというだけである。

ActivityType 一覧の最新情報は [Apple のドキュメント](https://developer.apple.com/documentation/uikit/uiactivity/activitytype)で確認できる。

| ActivityType       | 概要                                       |
| ------------------ | ------------------------------------------ |
| addToReadingList   | Safari のリーディングリストへ追加する      |
| airDrop            | Air Drop で近くの端末にシェアする          |
| assignToContact    | 連絡先 に ActivityItems を渡す             |
| copyToPasteboard   | ペーストボード(クリップボード)へコピーする |
| mail               | メール でシェアする                        |
| message            | メッセージ でシェアする                    |
| openInIBooks       | iBooks にPDFとして保存する                 |
| postToFacebook     | Facebook でシェアする                      |
| postToFlickr       | Flickr でシェアする                        |
| postToTencentWeibo | Tencent Weibo でシェアする                 |
| postToTwitter      | Twitter でシェアする                       |
| postToVimeo        | Viemo でシェアする                         |
| postToWeibo        | Weibo でシェアする                         |
| print              | 印刷する                                   |
| saveToCameraRoll   | カメラロールに保存する                     |
| markupAsPDF        | PDFを作成する                              |

ちなみに、**Activity で呼び出される各アプリは、端末にインストールされていなければ実行時に選択肢として表示されない**。

### ポイント3

**`completionWithItemsHandler`プロパティに完了時の処理を記述する**
これも任意だ。

サンプルコードでは`activityType`に応じて処理を変えている。

```swift
switch activityType {
case UIActivityType.postToTwitter:
    print("Tweeted")
case UIActivityType.print:
    print("Printed")
case UIActivityType.saveToCameraRoll:
    print("Saved to Camera Roll")
default:
    print("Done")
}
```

## 参考

- [UIActivityViewController | Apple 公式ドキュメント](https://developer.apple.com/documentation/uikit/uiactivityviewcontroller)
- [UIActivity.ActivityType | Apple 公式ドキュメント](https://developer.apple.com/documentation/uikit/uiactivity/activitytype)
- [[Swift]UIActivityの使い方まとめ | Qiita](https://qiita.com/nashirox/items/56894599013d712faa0a)
- [UIActivityViewController by example | HACKING WITH SWIFT](https://www.hackingwithswift.com/articles/118/uiactivityviewcontroller-by-example)
