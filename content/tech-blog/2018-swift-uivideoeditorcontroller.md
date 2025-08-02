---
title: "[Swift] 動画をトリミングする (UIVideoEditorController)"
# image: "/images/tech-blog/slug/image.jpg"
description: "UIVideoEditorController を使って動画をトリミングする方法を解説する。"
published: "2018-09-05"
updated: "2025-07-08"
category: "tech"
tags: ["swift", "ios", "video"]
---

## 概要

UIVideoEditorController を使うことで、動画をトリミングすることができる。

スクリーンショットの "Edit Video" という文字の下にある横長の枠で、トリミング範囲を選択する。

![動画エディター](/images/tech-blog/2018-swift-uivideoeditorcontroller/video-editor.avif)

## 実装方法

### 必須の実装

- UIVideoEditorController の delegate となるクラスに`UIVideoEditorControllerDelegate`と`UINavigationControllerDelegate`を継承させる
  `swift
class ViewController: UIViewController, UIVideoEditorControllerDelegate, UINavigationControllerDelegate {
...
}
    `
- `videoPath`と`delegate`を設定する
  `swift
let videoEditor: UIVideoEditorController = UIVideoEditorController()
let videoPath: String = Bundle.main.path(forResource: "video", ofType: "mov")!
videoEditor.videoPath = videoPath
videoEditor.delegate = self
    `
- UIVideoEditorController の view へ画面遷移する
  `swift
self.present(videoEditor, animated: true, completion: nil)
    `
- 実機でアプリを起動する (シミュレーターでは UIVideoEditorController を使えない)

### オプション

- 編集の保存完了時の処理の実装 (実質必須)
  `videoEditorController(_:didSaveEditedVideoToPath:)`メソッドを実装する
  `swift
func videoEditorController(_ editor: UIVideoEditorController, didSaveEditedVideoToPath editedVideoPath: String) {
    // CODE
}
    `
- 編集キャンセル時の処理の実装 (実質必須)
  `videoEditorControllerDidCancel(_:)`メソッドを実装する
  `swift
func videoEditorControllerDidCancel(_ editor: UIVideoEditorController) {
    // CODE
}
    `
- 動画の読込/保存時のエラーハンドリングの実装
  `videoEditorController(_ editor: UIVideoEditorController, didFailWithError error: Error)`メソッドを実装する
  `swift
func videoEditorController(_ editor: UIVideoEditorController, didFailWithError error: Error) {
    // CODE
}
    `
- 動画が編集可能かを調べる
  `swift
if UIVideoEditorController.canEditVideo(atPath: videoPath) {
    // editable
} else {
    // uneditable
}
    `
- 保存する画質を指定する
  次の画質から指定できる + typeLow (デフォルト) + typeMidium + typeHigh + type640x480 + typeIFrame960x540 + typeIFrame1280x720
  `swift
videoEditor.videoQuality = UIImagePickerController.QualityType.typeHigh
    `
- 編集後動画の最大の長さを指定する
  次のコードでは最大を5.0秒に指定している。
  `swift
videoEditor.videoMaximumDuration = 5.0
    `

## ソースコード

編集画面を表示するだけのコード

```swift
import UIKit

class ViewController: UIViewController, UIVideoEditorControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let videoEditor: UIVideoEditorController = UIVideoEditorController()
        let videoPath: String = Bundle.main.path(forResource: "video", ofType: "mov")!
        guard UIVideoEditorController.canEditVideo(atPath: videoPath) else { return }
        videoEditor.videoPath = videoPath
        videoEditor.delegate = self
        self.present(videoEditor, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func videoEditorController(_ editor: UIVideoEditorController, didSaveEditedVideoToPath editedVideoPath: String) {
        // CODE
        print(editedVideoPath)
    }

}
```

## 注意事項

記事執筆時点の UIVideoEditorControllerDelegate には バグ？ があり、  
一度の保存に対して`videoEditorController(_:didSaveEditedVideoToPath:)`メソッドが2度呼ばれる。  
(XCode 9.4.1, Swift 4.1.2 で再現することを確認済み)  
[https://stackoverflow.com/questions/50795848/uivideoeditorcontroller-delegate-method-called-twice](https://stackoverflow.com/questions/50795848/uivideoeditorcontroller-delegate-method-called-twice)

単純な対処として、既に呼ばれたかどうかを管理するフラグを用意するといいだろう。
