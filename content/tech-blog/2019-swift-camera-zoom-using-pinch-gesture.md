---
title: "[Swift] ピンチイン/ピンチアウトのジェスチャーでカメラをズームする"
# image: "/images/tech-blog/slug/image.jpg"
description: "AVCaptureSession を使ってカメラを利用するシーンにおいて、ピンチイン/ピンチアウトのジェスチャーで ズームイン/ズームアウト させる方法を紹介する。"
published: "2019-02-03"
updated: "2025-06-26"
category: "tech"
tags: ["ios", "swift", "camera"]
---

## コード全体

**ViewController.swift**

```swift
import UIKit
import AVFoundation

class ViewController: UIViewController {

    private var videoDevice: AVCaptureDevice?
    private var captureSession: AVCaptureSession? = nil
    private var videoLayer: AVCaptureVideoPreviewLayer? = nil

    private var baseZoomFanctor: CGFloat = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCamera()
        self.setupPinchGestureRecognizer()
    }

    private func setupCamera() {
        self.videoDevice = AVCaptureDevice.default(for: .video)
        let audioDevice = AVCaptureDevice.default(for: .audio)

        self.captureSession = AVCaptureSession()

        // add video input to a capture session
        let videoInput = try! AVCaptureDeviceInput(device: self.videoDevice!)
        self.captureSession?.addInput(videoInput)

        // add audio input to a capture session
        let audioInput = try! AVCaptureDeviceInput(device: audioDevice!)
        self.captureSession?.addInput(audioInput)

        // preview layer
        self.videoLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        self.videoLayer?.frame = self.view.bounds
        self.videoLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(self.videoLayer!)

        self.captureSession?.startRunning()
    }

    private func setupPinchGestureRecognizer() {
        // pinch recognizer for zooming
        let pinchGestureRecognizer: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.onPinchGesture(_:)))
        self.view.addGestureRecognizer(pinchGestureRecognizer)
    }

    @objc private func onPinchGesture(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            self.baseZoomFanctor = (self.videoDevice?.videoZoomFactor)!
        }

        let tempZoomFactor: CGFloat = self.baseZoomFanctor * sender.scale
        let newZoomFactdor: CGFloat
        if tempZoomFactor < (self.videoDevice?.minAvailableVideoZoomFactor)! {
            newZoomFactdor = (self.videoDevice?.minAvailableVideoZoomFactor)!
        } else if (self.videoDevice?.maxAvailableVideoZoomFactor)! < tempZoomFactor {
            newZoomFactdor = (self.videoDevice?.maxAvailableVideoZoomFactor)!
        } else {
            newZoomFactdor = tempZoomFactor
        }

        do {
            try self.videoDevice?.lockForConfiguration()
            self.videoDevice?.ramp(toVideoZoomFactor: newZoomFactdor, withRate: 32.0)
            self.videoDevice?.unlockForConfiguration()
        } catch {
            print("Failed to change zoom factor.")
        }
    }
}
```

[https://github.com/hahnah/til-swift/tree/master/CameraZoom](https://github.com/hahnah/til-swift/tree/master/CameraZoom)

## 概説

### 1. ピンチイン/ピンチアウトのジェスチャー認識をさせる

```swift
    private func setupPinchGestureRecognizer() {
        // pinch recognizer for zooming
        let pinchGestureRecognizer: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.onPinchGesture(_:)))
        self.view.addGestureRecognizer(pinchGestureRecognizer)
    }
```

これだけだ。  
`action`の部分には後述で定義する`onPinchGesture`メソッドを指定しており、ピンチジェスチャーが行われるとそれが呼び出される。  
(ちなみにジェスチャーの開始や終了時だけでなく、ジェスチャーの途中でも変化する度に呼び出される)。

### 2. ピンチイン/ピンチアウト時の処理としてズームを実装する

`onPinchGesture`メソッドにおいて、前半ではズームの倍率を計算し、後半ではズーム処理を行っている。

```swift
    private var baseZoomFanctor: CGFloat = 1.0

    @objc private func onPinchGesture(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            self.baseZoomFanctor = (self.videoDevice?.videoZoomFactor)!
        }

        let tempZoomFactor: CGFloat = self.baseZoomFanctor * sender.scale
        let newZoomFactdor: CGFloat
        if tempZoomFactor < (self.videoDevice?.minAvailableVideoZoomFactor)! {
            newZoomFactdor = (self.videoDevice?.minAvailableVideoZoomFactor)!
        } else if (self.videoDevice?.maxAvailableVideoZoomFactor)! < tempZoomFactor {
            newZoomFactdor = (self.videoDevice?.maxAvailableVideoZoomFactor)!
        } else {
            newZoomFactdor = tempZoomFactor
        }

        do {
            try self.videoDevice?.lockForConfiguration()
            self.videoDevice?.ramp(toVideoZoomFactor: newZoomFactdor, withRate: 32.0)
            self.videoDevice?.unlockForConfiguration()
        } catch {
            print("Failed to change zoom factor.")
        }
    }
```

#### 2-1. ズーム倍率の計算

ズーム倍率の計算には、`sender.scale`を使う。  
この`scale`プロパティは、ピンチジェスチャー開始時を基準とした拡縮倍率を表す。

`baseZoomFanctor`プロパティにピンチジェスチャー開始時の拡縮倍率を格納している。

```swift
        if sender.state == .began {
            self.baseZoomFanctor = (self.videoDevice?.videoZoomFactor)!
        }
```

次に、基準の拡縮倍率とジェスチャーによる拡縮倍率をかけ合わせ、新しい拡縮倍率を計算する(`tempZoomFactor`としておく)。  
ただし、これは拡縮倍率の下限〜上限の範囲内に収まっていない可能性がある。

```swift
        let tempZoomFactor: CGFloat = self.baseZoomFanctor * sender.scale
```

最後に、拡縮倍率の下限と上限の範囲内に収まるように調整する(`newZoomFactdor`)。

```swift
        let newZoomFactdor: CGFloat
        if tempZoomFactor < (self.videoDevice?.minAvailableVideoZoomFactor)! {
            newZoomFactdor = (self.videoDevice?.minAvailableVideoZoomFactor)!
        } else if (self.videoDevice?.maxAvailableVideoZoomFactor)! < tempZoomFactor {
            newZoomFactdor = (self.videoDevice?.maxAvailableVideoZoomFactor)!
        } else {
            newZoomFactdor = tempZoomFactor
        }
```

#### 2-2. ズーム処理

先程計算した`newZoomFactdor`を新たな拡縮倍率として、ズーム処理を行う。

```swift
            try self.videoDevice?.lockForConfiguration()
            self.videoDevice?.ramp(toVideoZoomFactor: newZoomFactdor, withRate: 32.0)
            self.videoDevice?.unlockForConfiguration()
```

ズーム処理については次の記事に説明があるので参照すると役に立つかもしれない。  
[[Swift] AVFoundation による動画撮影の設定: カメラ種類 / ズーム / 録画時間 / 画質](https://hahnah.github.io/tech-blog/2019-swift-avcapture-settings/)
