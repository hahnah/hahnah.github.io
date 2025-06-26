---
title: "[Swift] AVFoundation による動画撮影の設定: カメラ種類 / ズーム / 録画時間 / 画質"
# image: "/images/tech-blog/slug/image.jpg"
description: "AVCaptureSession を使ってカメラを利用するシーンにおいて、ピンチイン/ピンチアウトのジェスチャーで ズームイン/ズームアウト させる方法を紹介する。"
published: "2019-02-03"
updated: "2025-06-26"
category: "tech"
tags: ["ios", "swift", "camera"]
---

## 基本実装

まずは基本実装から。後ほど種々の設定について説明する。

次の実装では、

- 録画開始ボタンを押すと録画が始まり、
- 録画停止ボタンを押すと録画が終了し、
- 録画されたことを知らせるアラートが表示される

というだけの単純な実装になっている。

動画撮影のための特殊な設定はなく、デフォルト的な振る舞いになっている。

**ViewController.swift**

```swift
import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    let fileOutput = AVCaptureMovieFileOutput()

    var recordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.setUpCamera()
    }

    func setUpCamera() {
        let captureSession: AVCaptureSession = AVCaptureSession()
        let videoDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.video)
        let audioDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.audio)

        // video input setting
        let videoInput: AVCaptureDeviceInput = try! AVCaptureDeviceInput(device: videoDevice!)
        captureSession.addInput(videoInput)

        // audio input setting
        let audioInput = try! AVCaptureDeviceInput(device: audioDevice!)
        captureSession.addInput(audioInput)

        captureSession.addOutput(fileOutput)

        captureSession.startRunning()

        // video preview layer
        let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(videoLayer)

        // recording button
        self.recordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        self.recordButton.backgroundColor = UIColor.gray
        self.recordButton.layer.masksToBounds = true
        self.recordButton.setTitle("Record", for: .normal)
        self.recordButton.layer.cornerRadius = 20
        self.recordButton.layer.position = CGPoint(x: self.view.bounds.width / 2, y:self.view.bounds.height - 100)
        self.recordButton.addTarget(self, action: #selector(self.onClickRecordButton(sender:)), for: .touchUpInside)
        self.view.addSubview(recordButton)
    }

    @objc func onClickRecordButton(sender: UIButton) {
        if self.fileOutput.isRecording {
            // stop recording
            fileOutput.stopRecording()

            self.recordButton.backgroundColor = .gray
            self.recordButton.setTitle("Record", for: .normal)
        } else {
            // start recording
            let tempDirectory: URL = URL(fileURLWithPath: NSTemporaryDirectory())
            let fileURL: URL = tempDirectory.appendingPathComponent("mytemp1.mov")
            fileOutput.startRecording(to: fileURL, recordingDelegate: self)

            self.recordButton.backgroundColor = .red
            self.recordButton.setTitle("●Recording", for: .normal)
        }
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        // show alert
        let alert: UIAlertController = UIAlertController(title: "Recorded!", message: outputFileURL.absoluteString, preferredStyle:  .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
```

**NOTE** Info.plist に`Camera`と`Microphone`の許可を設定しておくこと。そうしないとアプリが異常終了する。  
[Accessing Protected Resources](https://developer.apple.com/documentation/uikit/core_app/protecting_the_user_s_privacy/accessing_protected_resources)

## カメラ種類の設定

`AVCaptureDevice`オブジェクトを`AVCaptureDevice.default(_:for:position:)`メソッドで初期化する際、利用するカメラの種類を設定することができる。

次の例では、背面のデュアルカメラを用いるように初期化している。

```swift
let videoDevice: AVCaptureDevice? = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back)
```

ちなみに、次のように`AVCaptureDevice.default(for:)`メソッドで初期化した場合には背面のワイドカメラに設定される。

```swift
let videoDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.video)
```

### ワイドカメラ / デュアルカメラ / ... の設定

`AVCaptureDevice.default(_:for:position:)`メソッドの第一引数に指定することで、以下の種類のカメラを利用できる。

- `.builtInWideAngleCamera`: ワイドカメラ（最もオーソドックスなカメラ）
- `.builtInDualCamera`: デュアルカメラ
- `.builtInTelephotoCamera`: 望遠カメラ
- `.builtInTrueDepthCamera`: デプスカメラ（カメラと一緒にデプスセンサーが働く）

ただし、iPhone/iPad/iPodTouch の機種によっては利用できないカメラ種類もあるので注意が必要。  
例えば、背面のデュアルカメラは iPhoneX では利用可能だが、iPhone8 では利用できない。

[公式ドキュメント](https://developer.apple.com/documentation/avfoundation/avcapturedevice/2361508-default)には、  
まず背面のデュアルカメラを利用できるかを確認してから、もしダメならば背面のワイドカメラの利用を試みる方法が紹介されている。

**&darr;公式ドキュメントより引用**

```swift
func defaultCamera() -> AVCaptureDevice? {
    if let device = AVCaptureDevice.default(.builtInDualCamera,
                                            for: AVMediaType.video,
                                            position: .back) {
        return device
    } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                        for: AVMediaType.video,
                        position: .back) {
        return device
    } else {
        return nil
    }
}
```

### 前面カメラ / 背面カメラ の設定

`AVCaptureDevice.default(_:for:position:)`メソッドの`position`引数に指定することで、前面カメラと背面カメラのどちらかを設定できる。

- `.front`: 前面カメラ。自撮りのときなどに。
- `.back`: 背面カメラ。通常の用途に。

## ズームの設定

`AVCaptureDevice.ramp(toVideoZoomFactor:withRate:)`メソッドにより、ズームイン / ズームアウト の設定ができる。

`toVideoZoomFactor`引数にはズームの拡大係数を指定する。  
この値は`minAvailableVideoZoomFactor`以上かつ`maxAvailableVideoZoomFactor`以下でなければならない。

`withRate`引数には 1.0 以上の値を指定する。  
この値が大きほど、高速にズームがされる。  
例えば`withRate`を最小値である 1.0 とした場合、非常にゆっくりと徐々にズームが働く。

```swift
do {
	try videoDevice?.lockForConfiguration()
	videoDevice?.ramp(toVideoZoomFactor: (self.videoDevice?.maxAvailableVideoZoomFactor)!, withRate: 1.0)
	self.videoDevice?.unlockForConfiguration()
} catch {
	print("Failed to change zoom.")
}
```

上記のコードにあるように、  
`ramp`メソッドを用いる際には、他のカメラ設定が変更されないように`lockForConfiguration`メソッドでロックをかけておく必要がある。  
`ramp`の後には`unlockForConfiguration`で解除すること。

### スライダーでズームを変更するサンプル

以下のように変更を加えることで、スライダーを動かす度に ズームイン / ズームアウト を動作させることができる。

```swift
class ViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {

	// onSliderChangedメソッドからアクセスできるようにプロバティ化する
	var videoDevice: AVCaptureDevice?

	//（中略）

	func setUpCamera() {
		//（中略)

		// ズーム用のスライダー
        let slider: UISlider = UISlider()
        let sliderWidth: CGFloat = self.view.bounds.width * 0.75
        let sliderHeight: CGFloat = 40
        let sliderRect: CGRect = CGRect(x: (self.view.bounds.width - sliderWidth) / 2, y: self.view.bounds.height - 200, width: sliderWidth, height: sliderHeight)
        slider.frame = sliderRect
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.0
        slider.addTarget(self, action: #selector(self.onSliderChanged(sender:)), for: .valueChanged)
        self.view.addSubview(slider)
	}

	// スライダーの値に応じて ズームイン / ズームアウトする
	@objc func onSliderChanged(sender: UISlider) {
        do {
            try self.videoDevice?.lockForConfiguration()
            self.videoDevice?.ramp(
                toVideoZoomFactor: (self.videoDevice?.minAvailableVideoZoomFactor)! + CGFloat(sender.value) * ((self.videoDevice?.maxAvailableVideoZoomFactor)! - (self.videoDevice?.minAvailableVideoZoomFactor)!),
                withRate: 30.0)
            self.videoDevice?.unlockForConfiguration()
        } catch {
            print("Failed to change zoom.")
        }
    }

	//（以下略）
}
```

### ピンチイン/ピンチアウトのジェスチャーでズームを変更するサンプル

次の記事で紹介している。  
[[Swift] ピンチイン/ピンチアウトのジェスチャーでカメラをズームする](https://hahnah.github.io/tech-blog/2019-swift-camera-zoom-using-pinch-gesture/)

## 録画の最長時間の設定

`AVCaptureMovieFileOutput`オブジェクトの`maxRecordedDuration`プロパティに録画時間のMAX を指定できる。

例えば以下では、録画時間のMAXを60秒に設定している。

```swift
fileOutput.maxRecordedDuration = CMTimeMake(value: 60, timescale: 1)
```

次の例では、録画時間のMAXが5分に設定される。

```swift
fileOutput.maxRecordedDuration = CMTimeMake(value: 5, timescale: 60)
```

## 画質の設定

画質の設定は`AVCaptureSession.sessionPreset`プロパティで行う。

例えば以下のような画質が用意されている

- `.low`: 低画質
- `.medium`: 中画質
- `.high`: 高画質
- `.hd1920x1080`:フルHD画質
- `.hd4K3840x2160`: 4K画質

ここに挙げたものはほんの一部に過ぎず、他にも数々の画質設定が用意されている。  
[AVCaptureSession.Preset](https://developer.apple.com/documentation/avfoundation/avcapturesession/preset)

`AVCaptureSession.sessionPreset`プロパティに値を代入して画質設定を変更するには、  
設定変更前に`beginConfiguration`メソッドを、  
設定変更後に`commitConfiguration`メソッドを呼ぶこと。  
(実はAVCaptureSessionのセッションが実行されていない時であれば呼ぶ必要はないらしいのだが、常に呼んでおくのが無難だろう。)

それと、設定しようとしている画質が利用可能かを`canSetSessionPreset`メソッドで調べることもしておこう。

```swfit
captureSession.beginConfiguration()
if captureSession.canSetSessionPreset(.hd4K3840x2160) {
	captureSession.sessionPreset = .hd4K3840x2160
} else if captureSession.canSetSessionPreset(.high) {
	captureSession.sessionPreset = .high
}
captureSession.commitConfiguration()
```

## その他動画出力に関わる設定

`AVCaptureMovieFileOutput`クラスを用いて様々に動画出力を設定できる。  
以下の公式ドキュメントに目を通すと多くの情報が得られるだろう。

- [AVCaptureMovieFileOutput](https://developer.apple.com/documentation/avfoundation/avcapturemoviefileoutput)
- [AVCaptureMovieFileOutput.setOutputSettings(\_:for:)](https://developer.apple.com/documentation/avfoundation/avcapturemoviefileoutput/1388448-setoutputsettings)
- [Video Settings Dictionaries](https://developer.apple.com/documentation/avfoundation/avassetwriterinput/video_settings_dictionaries)

## もりもりのサンプルコード

[https://github.com/hahnah/til-swift/blob/master/AVCapture/](https://github.com/hahnah/til-swift/blob/master/AVCapture/)

```swift
//
//  ViewController.swift
//  AVCapture
//
//  Copyright © 2019 hahnah. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {

    var videoDevice: AVCaptureDevice?
    let fileOutput = AVCaptureMovieFileOutput()

    var recordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.setUpCamera()
    }

    func setUpCamera() {
        let captureSession: AVCaptureSession = AVCaptureSession()
        self.videoDevice = self.defaultCamera()
        let audioDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.audio)

        // video input setting
        let videoInput: AVCaptureDeviceInput = try! AVCaptureDeviceInput(device: videoDevice!)
        captureSession.addInput(videoInput)

        // audio input setting
        let audioInput = try! AVCaptureDeviceInput(device: audioDevice!)
        captureSession.addInput(audioInput)

        // max duration setting
        self.fileOutput.maxRecordedDuration = CMTimeMake(value: 60, timescale: 1)

        captureSession.addOutput(fileOutput)

        // video quality setting
        captureSession.beginConfiguration()
        if captureSession.canSetSessionPreset(.hd4K3840x2160) {
            captureSession.sessionPreset = .hd4K3840x2160
        } else if captureSession.canSetSessionPreset(.high) {
            captureSession.sessionPreset = .high
        }
        captureSession.commitConfiguration()

        captureSession.startRunning()

        // video preview layer
        let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(videoLayer)

        // zooming slider
        let slider: UISlider = UISlider()
        let sliderWidth: CGFloat = self.view.bounds.width * 0.75
        let sliderHeight: CGFloat = 40
        let sliderRect: CGRect = CGRect(x: (self.view.bounds.width - sliderWidth) / 2, y: self.view.bounds.height - 200, width: sliderWidth, height: sliderHeight)
        slider.frame = sliderRect
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.0
        slider.addTarget(self, action: #selector(self.onSliderChanged(sender:)), for: .valueChanged)
        self.view.addSubview(slider)

        // recording button
        self.recordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        self.recordButton.backgroundColor = UIColor.gray
        self.recordButton.layer.masksToBounds = true
        self.recordButton.setTitle("Record", for: .normal)
        self.recordButton.layer.cornerRadius = 20
        self.recordButton.layer.position = CGPoint(x: self.view.bounds.width / 2, y:self.view.bounds.height - 100)
        self.recordButton.addTarget(self, action: #selector(self.onClickRecordButton(sender:)), for: .touchUpInside)
        self.view.addSubview(recordButton)
    }

    func defaultCamera() -> AVCaptureDevice? {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
            return device
        } else {
            return nil
        }
    }

    @objc func onClickRecordButton(sender: UIButton) {
        if self.fileOutput.isRecording {
            // stop recording
            fileOutput.stopRecording()

            self.recordButton.backgroundColor = .gray
            self.recordButton.setTitle("Record", for: .normal)
        } else {
            // start recording
            let tempDirectory: URL = URL(fileURLWithPath: NSTemporaryDirectory())
            let fileURL: URL = tempDirectory.appendingPathComponent("mytemp1.mov")
            fileOutput.startRecording(to: fileURL, recordingDelegate: self)

            self.recordButton.backgroundColor = .red
            self.recordButton.setTitle("●Recording", for: .normal)
        }
    }

    @objc func onSliderChanged(sender: UISlider) {
        do {
            try self.videoDevice?.lockForConfiguration()
            self.videoDevice?.ramp(
                toVideoZoomFactor: (self.videoDevice?.minAvailableVideoZoomFactor)! + CGFloat(sender.value) * ((self.videoDevice?.maxAvailableVideoZoomFactor)! - (self.videoDevice?.minAvailableVideoZoomFactor)!),
                withRate: 30.0)
            self.videoDevice?.unlockForConfiguration()
        } catch {
            print("Failed to change zoom.")
        }
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        // show alert
        let alert: UIAlertController = UIAlertController(title: "Recorded!", message: outputFileURL.absoluteString, preferredStyle:  .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
```
