---
title: "[Swift] 動画をエクスポート・保存する"
# image: "/images/tech-blog/slug/image.jpg"
description: "iPhone のフォトアルバムにある動画をアプリ内に保存する方法を紹介する。"
published: "2018-09-17"
updated: "2025-07-02"
category: "tech"
tags: ["ios", "swift", "video"]
---

iPhone のフォトアルバムにある動画をアプリ内に保存したい場面に遭遇したので、それを実現してみた。  
フォトアルバム内の動画に限った方法ではないので、それ以外のケースでも利用できるはず。

## 動画ファイルのエクスポート

次に定義する`exportMovie`関数は、  
引数`sorceURL`にある動画を、`destinationURL`へ`fileType`の形式で出力する。

ちなみに、タイムラプスなどの音声なしの動画にも対応している。

```swift
func exportMovie(sourceURL: URL, destinationURL: URL, fileType: AVFileType) -> Void {

    let avAsset: AVAsset = AVAsset(url: sourceURL)

    // video と audio のトラックをそれぞれ取得
    let videoTrack: AVAssetTrack = avAsset.tracks(withMediaType: AVMediaType.video)[0]
    let audioTracks: [AVAssetTrack] = avAsset.tracks(withMediaType: AVMediaType.audio)
    let audioTrack: AVAssetTrack? =  audioTracks.count > 0 ? audioTracks[0] : nil

    let mainComposition : AVMutableComposition = AVMutableComposition()

    // video と audio のコンポジショントラックをそれぞれ作成
    let compositionVideoTrack: AVMutableCompositionTrack = mainComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!
    let compositionAudioTrack: AVMutableCompositionTrack? = audioTrack != nil
        ? mainComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!
        : nil

    // コンポジションの設定
    try! compositionVideoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, avAsset.duration), of: videoTrack, at: kCMTimeZero)
    try! compositionAudioTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, avAsset.duration), of: audioTrack!, at: kCMTimeZero)

    // エクスポートするためのセッションを作成
    let assetExport = AVAssetExportSession.init(asset: mainComposition, presetName: AVAssetExportPresetMediumQuality)

    // エクスポートするファイルの種類を設定
    assetExport?.outputFileType = fileType

    // エクスポート先URLを設定
    assetExport?.outputURL = destinationURL

    // エクスポート先URLに既にファイルが存在していれば、削除する (上書きはできないようなので)
    if FileManager.default.fileExists(atPath: (assetExport?.outputURL?.path)!) {
        try! FileManager.default.removeItem(atPath: (assetExport?.outputURL?.path)!)
    }
    // エクスポートする
    assetExport?.exportAsynchronously(completionHandler: {
        // エクスポート完了後に実行したいコードを記述
    })

}
```

`exportMovie`関数は次の様に利用する。

```swift
// 保存したい動画のURL。例えば UIImagePickerController で取得した動画のURLなど
let sourcURL: URL = yourSourceURL
// アプリ内 Document ディレクトリの に`yourMovieFileName.mov`という名前で保存したいものとする
let documentsDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
let destinationURL: URL = documentsDirectory.appendingPathComponent("yourMovieFileName.mov")
let fileType: AVFileType = AVFileType.mov
// 動画をエクスポートする
exportMovie(sourceURL: sourceURL, destinationURL: destinationURL, fileType: fileType)
```
