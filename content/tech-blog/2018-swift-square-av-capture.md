---
title: "[Swift] 正方形の動画を撮影する (動画の加工)"
# image: "/images/tech-blog/slug/image.jpg"
description: "iOSで正方形の動画を撮影する方法を紹介する。実際には正方形の動画を撮影しているわけではなく、動画を正方形に加工している。"
published: "2018-10-19"
updated: "2025-06-20"
category: "tech"
tags: ["ios", "swift", "camera"]
---

本記事の方法では、次の処理によって正方形の動画撮影を実現している。

1. 撮影のプレビュー画面を正方形にする
2. 動画を撮影する (長方形で撮影される)
3. 撮影した動画を正方形にクロッピングする
4. 動画をフォトライブラリに保存する

## 実装環境

- Swift 4.2
- iOS 12.0
- Xcode 10.0

## 準備

動画を撮影する際には次の２つのプライバシーの設定を info.plist に記述する必要がある。

- Privacy - Camera Usage Description
- Privacy - Microphone Usage Description

また、フォトライブラリに保存するためには次のものが必要になる。

- Privacy - Photo Library Usage Description

## サンプルコード

[GitHub](https://github.com/hahnah/til-swift/tree/master/SquareAVCapture)にプロジェクトごと置いてあるので、そちらで試すこともできる。

**ViewController.swift**

```swift
import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    let fileOutput = AVCaptureMovieFileOutput()

    var recordButton: UIButton!
    var isRecording = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.setUpCamera()
    }

    func setUpCamera() {
        let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
        let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
        let captureSession = AVCaptureSession()

        // 映像入力を設定
        let videoInput = try! AVCaptureDeviceInput(device: videoDevice!)
        captureSession.addInput(videoInput)

        // 音声入力を設定
        let audioInput = try! AVCaptureDeviceInput(device: audioDevice!)
        captureSession.addInput(audioInput)

        // 動画の最大時間を 60秒 に設定
        self.fileOutput.maxRecordedDuration = CMTimeMake(value: 60, timescale: 1)
        captureSession.addOutput(fileOutput)

        // ★★★ 1. 撮影のプレビュー画面を正方形にする ★★★
        let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer.frame = CGRect(x: 0, y: (self.view.bounds.height - self.view.bounds.width) / 2, width: self.view.bounds.width, height: self.view.bounds.width)
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(videoLayer)

        // カメラ(とマイク)のセッションを開始
        captureSession.startRunning()

        // 録画ボタンを配置
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
        // ★★★ 2. 動画を撮影する (長方形で撮影される) ★★★
        if !self.isRecording {
            // 録画を開始
            let tempDirectory: URL = URL(fileURLWithPath: NSTemporaryDirectory())
            let fileURL: URL = tempDirectory.appendingPathComponent("mytemp1.mov")
            fileOutput.startRecording(to: fileURL, recordingDelegate: self)

            self.isRecording = true
            self.recordButton.backgroundColor = .red
            self.recordButton.setTitle("●Recording", for: .normal)
        } else {
            // 録画を終了
            fileOutput.stopRecording()

            self.isRecording = false
            self.recordButton.backgroundColor = .gray
            self.recordButton.setTitle("Record", for: .normal)
        }
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        let tempDirectory: URL = URL(fileURLWithPath: NSTemporaryDirectory())
        let croppedMovieFileURL: URL = tempDirectory.appendingPathComponent("mytemp2.mov")

        // 録画された動画を正方形にクロッピングする
        MovieCropper.exportSquareMovie(sourceURL: outputFileURL, destinationURL: croppedMovieFileURL, fileType: .mov, completion: {
            // 正方形にクロッピングされた動画をフォトライブラリに保存
            self.saveToPhotoLibrary(fileURL: croppedMovieFileURL)
        })
    }

    func saveToPhotoLibrary(fileURL: URL) {
        // ★★★ 4. 動画をフォトライブラリに保存する ★★★
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
        }) { saved, error in
            let success = saved && (error == nil)
            let title = success ? "Success" : "Error"
            let message = success ? "Video saved." : "Failed to save video."

            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
```

**MovieCropper.swift**

```swift
import Foundation
import UIKit
import AVKit

final class MovieCropper {

    // ★★★ 3. 撮影した動画を正方形にクロッピングする ★★★
    static func exportSquareMovie(sourceURL: URL, destinationURL: URL, fileType: AVFileType, completion: (() -> Void)?) {

        let avAsset: AVAsset = AVAsset(url: sourceURL)

        let videoTrack: AVAssetTrack = avAsset.tracks(withMediaType: AVMediaType.video)[0]
        let audioTracks: [AVAssetTrack] = avAsset.tracks(withMediaType: AVMediaType.audio)
        let audioTrack: AVAssetTrack? =  audioTracks.count > 0 ? audioTracks[0] : nil

        let mixComposition : AVMutableComposition = AVMutableComposition()

        let compositionVideoTrack: AVMutableCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!
        let compositionAudioTrack: AVMutableCompositionTrack? = audioTrack != nil
            ? mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!
            : nil

        try! compositionVideoTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: avAsset.duration), of: videoTrack, at: CMTime.zero)
        try! compositionAudioTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: avAsset.duration), of: audioTrack!, at: CMTime.zero)

        compositionVideoTrack.preferredTransform = videoTrack.preferredTransform

        var croppedVideoComposition: AVMutableVideoComposition? = nil

        let squareEdgeLength: CGFloat = videoTrack.naturalSize.height
        let croppingRect: CGRect = CGRect(x: (videoTrack.naturalSize.width - squareEdgeLength) / 2, y: 0, width: squareEdgeLength, height: squareEdgeLength)
        let transform: CGAffineTransform = videoTrack.preferredTransform.translatedBy(x: -croppingRect.minX, y: -croppingRect.minY)

        // layer instruction を正方形に
        let layerInstruction: AVMutableVideoCompositionLayerInstruction = AVMutableVideoCompositionLayerInstruction.init(assetTrack: compositionVideoTrack)
        layerInstruction.setCropRectangle(croppingRect, at: CMTime.zero)
        layerInstruction.setTransform(transform, at: CMTime.zero)

        // instruction に、先程の layer instruction を設定する
        let instruction: AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: avAsset.duration)
        instruction.layerInstructions = [layerInstruction]

        // video composition に、先程の instruction を設定する。また、レンダリングの動画サイズを正方形に設定する
        croppedVideoComposition = AVMutableVideoComposition()
        croppedVideoComposition?.instructions = [instruction]
        croppedVideoComposition?.frameDuration = CMTimeMake(value: 1, timescale: 30)
        croppedVideoComposition?.renderSize = CGSize(width: squareEdgeLength, height: squareEdgeLength)

        // エクスポートの設定。先程の video compsition をエクスポートに使うよう設定する。
        let assetExport = AVAssetExportSession.init(asset: mixComposition, presetName: AVAssetExportPresetMediumQuality)
        assetExport?.outputFileType = fileType
        assetExport?.outputURL = destinationURL
        if let videoComposition = croppedVideoComposition {
            assetExport?.videoComposition = videoComposition
        }

        // エクスポート先URLに既にファイルが存在していれば、削除する (上書きはできないので)
        if FileManager.default.fileExists(atPath: (assetExport?.outputURL?.path)!) {
            try! FileManager.default.removeItem(atPath: (assetExport?.outputURL?.path)!)
        }

        // クロップした動画をエクスポート
        assetExport?.exportAsynchronously(completionHandler: {
            if let completionHandler = completion {
                completionHandler()
            }
        })

    }

}
```
