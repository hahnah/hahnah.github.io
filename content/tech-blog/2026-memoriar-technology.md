---
title: "ARで動画を飾れるアプリ「MemoriaR」を作った話 -  写真アプリとCloudKitの同期を組み合わせる設計"
# image: "/images/tech-blog/slug/image.jpg"
description: "iOSアプリMemoriaRの技術的な工夫として、iCloud Photosの同期とCoreData（CloudKit）の同期を組み合わせることで、アプリが扱うデータ量を最小化した設計について紹介します。"
published: "2026-01-27"
# updated: "2025-02-20"
category: "tech"
tags: ["memoriar", "ios", "icloud", "cloudkit", "coredata"]
---

## はじめに

「動画を、飾れる思い出に。」

そんなコンセプトで、**MemoriaR**（メモリア）というiOSアプリをリリースしました。  
以下の記事で詳しく紹介しています。  
[MemoriaR ― 動画を、飾れる思い出に](https://hahnah.github.io/tech-blog/2026-memoriar-ja/)

印刷した写真にiPhoneをかざすと、その写真に紐づいた動画がARで再生される——写真と動画を
組み合わせて、思い出を「飾れる」形で残せるムービーアルバムアプリです。

![動作イメージ](/images/tech-blog/2026-memoriar-en/ar-session-capture.gif#width=300)

この記事では、MemoriaRの概要と作成背景、そして技術的な工夫として**iCloud Photosの同期とCoreData（CloudKit）の同期を組み合わせることで、アプリが扱うデータ量を最小化した設計**について紹介します。

## MemoriaRとは

MemoriaRは、動画をまったく新しい形で楽しめるアプリです。

通常、動画はスマートフォンの中で「見るだけ」の存在になりがちです。撮影したものの、気づけばほとんど見返さなくなってしまう——そんな経験はないでしょうか。

MemoriaRでは、**印刷した写真が動画への鍵**になります。

1. アプリで動画を撮影（または既存の動画を取り込む）
2. 動画から写真を書き出して印刷
3. 印刷した写真にデバイスをかざすと、ARで動画が再生される

壁に飾った写真、アルバムに収めた写真。それらにデバイスをかざすだけで、その場所に対応した動画が再生され、まるで思い出の時間がよみがえるような体験ができます。

⭐️ [MemoriaRをインストール](https://apps.apple.com/jp/app/memoriar/id6751318419) ⭐️

## 作成背景

写真は、物理的な場所に存在します。壁や机の上、棚の片隅に置かれ、ふとした瞬間に記憶を呼び起こしてくれます。

一方で動画は、より多くの情報を持っているにもかかわらず、多くの場合「データ」としてデバイスの中に閉じ込められています。

**もし動画も、写真のように残せたら。**

その発想からMemoriaRは生まれました。動画を単なるファイルとして保存するのではなく、現実の空間と結びついた記憶として残したい——そんな想いを形にしたアプリです。

## 技術的な工夫：ハイブリッド同期アーキテクチャ

MemoriaRには、同じApple Accountを使っているiPhone・iPad間でアルバムを同期する機能があります（プレミアム機能）。

ここで問題になるのが、**動画データのサイズ**です。

動画は写真に比べてファイルサイズが大きく、CloudKitの容量制限やネットワーク帯域を考えると、動画データをそのままCloudKitに保存するのは現実的ではありません。

### 解決策：2つの同期を組み合わせる

MemoriaRでは、以下の2つの同期機構を組み合わせる設計を採用しました。

| 同期対象             | 同期方法                          | 保存されるもの       |
| -------------------- | --------------------------------- | -------------------- |
| 写真・動画の実データ | **iCloud Photos**（Photosアプリ） | メディアファイル本体 |
| メタデータ           | **CloudKit**（CoreData）          | 関連付け情報のみ     |

### メタデータのみをCloudKitで同期

CloudKitで同期するのは、以下のような**メタデータのみ**です。

- `MemoryEntity`：写真のID、クラウドID、作成日時（約500バイト）
- `PhotoVideoRelationshipEntity`：写真と動画の関連付け（約200バイト）
- `AlbumEntity`：アルバム情報、並び順

**実際の写真・動画データは一切CloudKitに保存しません。**

メディアデータの同期は、iOSの標準機能である**iCloud Photos**に任せます。ユーザーがiCloud
Photosを有効にしていれば、写真・動画は自動的にデバイス間で同期されます。

### cloudIdentifierによるデバイス間の紐付け

ここで重要になるのが、デバイス間で写真を特定する方法です。

PhotoKitの`PHAsset`には`localIdentifier`というIDがありますが、これは**デバイスごとに異なる**値になります。同じ写真でも、iPhoneとiPadでは異なるIDが割り当てられます。

そこで使うのが`PHCloudIdentifier`です。これは**iCloud全体で一意のID**であり、同じApple Accountを使っているすべてのデバイスで共通です。

```swift
// 写真・動画作成時の保存フロー
  func createMemory(from asset: PHAsset) {
      // ローカルID（デバイス固有）
      let localId = asset.localIdentifier

      // クラウドID（iCloud全体で共通）
      let cloudId = try? PHPhotoLibrary.shared()
          .cloudIdentifierMappings(forLocalIdentifiers: [localId])
          .values.first?.get()

      // CoreDataに両方保存
      let entity = MemoryEntity(context: context)
      entity.photoAssetID = localId        // 現在のデバイス用
      entity.cloudIdentifier = cloudId?.stringValue  // 同期用
  }
```

別のデバイスでCloudKitからメタデータを受け取ったとき、以下の処理を行います。

```swift
// 別デバイスでの復元フロー
func resolveMemory(from entity: MemoryEntity) -> PHAsset? {
    guard let cloudIdString = entity.cloudIdentifier else { return nil }

    // 1. cloudIdentifierから現在のデバイスのlocalIdentifierを取得
    let cloudId = PHCloudIdentifier(stringValue: cloudIdString)
    let mapping = PHPhotoLibrary.shared().localIdentifierMappings(for: [cloudId])

    // 2. Result型から値を取り出す
    guard let localId = try? mapping[cloudId]?.get() else { return nil }

    // 3. ローカルIDを更新して次回以降の検索を高速化
    entity.photoAssetID = localId

    // 4. PHAssetを取得
    return PHAsset.fetchAssets(
        withLocalIdentifiers: [localId],
        options: nil
    ).firstObject
}
```

この設計により、CloudKitで同期するデータは数百バイトのメタデータのみ。動画のサイズが数十MB〜数百MBあっても、アプリのCloudKit使用量には影響しません。

#### アーキテクチャ図

```
  ┌────────────────────────────────────────────────────────────┐
  │                      デバイス A                         　   │
  ├────────────────────────────────────────────────────────────┤
  │  ┌──────────────┐      ┌──────────────┐                    │
  │  │ Photosアプリ  │      │   CoreData   │                    │
  │  │ (PHAsset)    │      │ (メタデータ)   │                    │
  │  │              │      │              │                    │
  │  │ localId: A1  │◄────►│ cloudId: C1  │                    │
  │  │ 動画: 50MB    │      │ localId: A1  │                    │
  │  └──────────────┘      └──────────────┘                    │
  │         │                     │                            │
  └─────────│─────────────────────│────────────────────────────┘
            │                     │
            ▼                     ▼
     ┌──────────────┐      ┌──────────────┐
     │iCloud Photos │      │   CloudKit   │
     │  (50MB同期)   │      │ (500B同期)   │
     └──────────────┘      └──────────────┘
            │                     │
            ▼                     ▼
  ┌─────────│─────────────────────│────────────────────────────┐
  │         │                     │                            │
  │  ┌──────────────┐      ┌──────────────┐                    │
  │  │ Photosアプリ  │      │   CoreData   │                    │
  │  │ (PHAsset)    │      │ (メタデータ)   │                    │
  │  │              │      │              │                    │
  │  │ localId: B1  │◄────►│ cloudId: C1  │                    │
  │  │ 動画: 50MB    │      │ localId: B1  │ ← 変換後            │
  │  └──────────────┘      └──────────────┘                    │
  │                                                            │
  │                      デバイス B                             │
  └────────────────────────────────────────────────────────────┘
```

#### この設計のメリット

1. アプリ内データ容量の節約:メタデータのみを扱い、大容量の動画を保存しなくて良い
2. CloudKitの容量を節約：メタデータのみなので、数KB程度で済む
3. 同期が高速：小さなデータなのでほぼ即座に同期される
4. 既存のエコシステムを活用：iCloud Photosという信頼性の高い仕組みを利用

#### 実装上の注意点

この設計を実装する際に気をつけた点をいくつか紹介します。

1. cloudIdentifierの取得タイミング
   PHCloudIdentifierは、写真がiCloudにアップロードされた後でないと取得できない場合があります。作成直後はnilになることがあるため、リトライ処理が必要です。
2. 孤児データの掃除
   Photosアプリで写真が削除されると、CoreData側のメタデータだけが残ってしまいます。定期的に孤児となったエンティティをクリーンアップする処理を入れています。
3. オフライン時の考慮
   iCloud Photosの同期が完了していないデバイスでは、cloudIdentifierからの変換に失敗します。その場合はプレースホルダーを表示し、写真・動画のダウンロード完了後に再度解決を試みます。

#### まとめ

MemoriaRでは、写真アプリ（iCloud Photos）とCoreData（CloudKit）の2つの同期機構を組み合わせることで、大容量の動画データを効率的に同期する設計を実現しました。

- メディアデータ → iCloud Photos（既存のエコシステムを活用）
- メタデータ → CloudKit（軽量な関連付け情報のみ）
- 紐付け → PHCloudIdentifier（デバイス間で一意のID）

この「ハイブリッド同期」アーキテクチャは、動画や写真を扱う他のアプリでも応用できる設計パターンだと思います。

## 最後に

「動画も写真のように残せたらいいのに」——そう感じたことがある方は、ぜひMemoriaRを試してみてください。基本無料で利用できます。

旅行の思い出、家族との日常、人生の節目、何気ない一日。忘れたくない瞬間を、いつでも思い出せる形で残せます。

⭐️ [MemoriaRをインストール](https://apps.apple.com/jp/app/memoriar/id6751318419) ⭐️
