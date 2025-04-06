---
title: "ARKitでのイメージトラッキング/画像認識において Invalid Reference Image を特定する"
image: "/images/tech-blog/2019-arkit-invalid-reference-image/staggered-arkit.avif"
description: "ARKitでの画像認識時に発生する Invalid reference image というエラーの原因を実行時に特定し対処する方法の紹介"
published: "2019-07-04"
updated: "2025-04-06"
category: "tech"
tags: ["ar", "ios", "arkit", "swift"]
---

## ARKit における Invalid Reference Image とは

ARKit で`ARImageTrackingConfiguration`もしくは`ARWorldTrackingConfiguration`を使っていると、**`Invalid reference image`** というランタイムエラーに遭遇することがある。

これは、`ARImageTrackingConfiguration.trackingImages`(イメージトラッキング用) または`ARWorldTrackingConfiguration.detectionImages`(画像認識用) にセットされた画像が、トラッキングや画像認識に利用できないときに起こる。(ARセッションの実行時に起こる。)

#### 追記 (2019/07/06)

iOS 13.0+ (ARKit 3.0)からは `ARReferenceImage`クラスの [validate](https://developer.apple.com/documentation/arkit/arreferenceimage/3194594-validate) メソッドを使って、有効な Reference Image かどうかをチェックできる。 型を見る限り、Error も拾えるようだ。  
そちらを使うのが良いかも。

#### この記事で知れること:

- Invalid Reference Image のエラーパターンを、プログラムで特定する方法
- どの Reference Image にエラーの原因があるのかを、プログラムで特定する方法

#### 想定読者について

この記事は、Invalid Reference Image にプログラムで対処したい人に向けて書いている。  
例えば、「Reference Image をアプリのユーザーが登録する」 機能を開発している人など。

Reference Image を始めからアプリにバンドルする場合は、Xcode が出す警告に従うだけでよいはずなので、それはこの記事でカバーしていない。

#### 筆者の環境

- Swift 5.0
- ARKit 2
- Xcode 10.2.1
- iOS 12.2

## とりあえずエラー内容を見てみる

ARセッションのランタイムエラーは`ARSessionDelegate`の [session(\_ session: ARSession, didFailWithError error: Error)](https://developer.apple.com/documentation/arkit/arsessionobserver/2887453-session) を実装することで拾える。

まずは拾ったエラーをログに出してみる。

```swift
import ARKit

extension MyARViewController: ARSessionDelegate {

    func session(_ session: ARSession, didFailWithError error: Error) {
        if let arErrorInfo: ARError = error as? ARError {
            print(arErrorInfo.errorUserInfo)
        }
    }

}
```

以下のようなエラーログが出力される。

```
▿ 4 elements
  ▿ 0 : 2 elements
    - key : "NSLocalizedFailureReason"
    - value : One or more reference images have insufficient texture: file:///var/mobile/Containers/Data/Application/A55C7B34-E1AB-4892-9160-E0287C3351C0/Documents/F5678103-A653-4C1E-9616-9EC198FEBDE6.mov, file:///var/mobile/Containers/Data/Application/A55C7B34-E1AB-4892-9160-E0287C3351C0/Documents/05BA2ECD-0B7A-44B8-87EB-77DB44B80B53.mov
  ▿ 1 : 2 elements
    - key : "NSLocalizedRecoverySuggestion"
    - value : One or more images lack sufficient texture and contrast for accurate detection. Image detection works best when an image contains multiple high-contrast regions distributed across its extent.
  ▿ 2 : 2 elements
    - key : "NSLocalizedDescription"
    - value : Invalid reference image.
  ▿ 3 : 2 elements
    - key : "ARErrorItems"
    ▿ value : 2 elements
      - 0 : file:///var/mobile/Containers/Data/Application/A55C7B34-E1AB-4892-9160-E0287C3351C0/Documents/F5678103-A653-4C1E-9616-9EC198FEBDE6.mov
      - 1 : file:///var/mobile/Containers/Data/Application/A55C7B34-E1AB-4892-9160-E0287C3351C0/Documents/05BA2ECD-0B7A-44B8-87EB-77DB44B80B53.mov
```

**大雑把には、以下のことがログとして出てくる:**

- `"NSLocalizedFailureReason"`: エラーの詳細（エラー理由とエラーになる画像のファイルパスを出してくれている)
- `"NSLocalizedRecoverySuggestion"`: エラーにならないために、どうあればいいか
- `"NSLocalizedDescription"`: エラーの概要
- `"ARErrorItems"`: エラーの原因になっている画像のファイルパス一覧

**上記エラーログ例を読んでみると、次のことが分かる:**

- エラー概要: Invalid Reference Image
- エラー原因: Reference Image に、正確な検出に十分なテクスチャとコントラストがない
- エラーの原因になってるファイル:
  - file:///var/mobile/Containers/Data/Application/A55C7B34-E1AB-4892-9160-E0287C3351C0/Documents/F5678103-A653-4C1E-9616-9EC198FEBDE6.mov
  - file:///var/mobile/Containers/Data/Application/A55C7B34-E1AB-4892-9160-E0287C3351C0/Documents/05BA2ECD-0B7A-44B8-87EB-77DB44B80B53.mov
- エラーへの対処方法: Reference Image に、正確な検出に十分なテクスチャとコントラストを持たせる（まんべんなく分散した高コントラストな部分がイメージに含まれる場合に最適に動作する）

**補足:**

- エラーログが英語だが、日本語でも出せる (アプリの対応言語とiPhoneの言語設定を日本語にする)
- `ARError`型にキャストしてログ出力しているが、`NSError`型にキャストした場合は少し違ったログが見られる（エラードメインやエラーコードなど）が、ここでは割愛する。ちなみに、エラードメインは`com.apple.arkit.error`, エラーコードは原因の詳細によらず`300`だったので私にとっては役に立たなかった。

## エラーを判別してユーザーに対処を促す

私の場合は`arErrorInfo.errorUserInfo["NSLocalizedRecoverySuggestion"]`の値でエラー原因を判別し、`arErrorInfo.errorUserInfo["ARErrorItems"]`の値から原因となっているファイルを特定した上で、ユーザーに対処を促すようにしている。

### エラーパターンの判別

私が知り得た範囲では、`"NSLocalizedRecoverySuggestion"`には次の2パターンがある。

|     | Englishログ                                                                                                                                                                                       | 日本語ログ                                                                                                                                                                                                |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ①   | "One or more images lack sufficient texture and contrast for accurate detection. Image detection works best when an image contains multiple high-contrast regions distributed across its extent." | "1つまたは複数のイメージに正確な検出に十分なテクスチャとコントラストがありません。イメージの検出は、その範囲に渡ってまんべんなく分散した高コントラストな部分がイメージに含まれる場合に最適に作動します。" |
| ②   | "Make sure that all reference images are greater than 100 pixels and have a positive physical size in meters."                                                                                    | "参照イメージがすべて100ピクセルより大きく、メートルで正の物理的なサイズがあることを確認してください。"                                                                                                   |

`arErrorInfo.errorUserInfo["NSLocalizedRecoverySuggestion"]`(String値)が上記のどれと一致するかで原因を判別する。

**複数の Reference Image に①のものと②のものが混在する場合、どちらか一方のパターンのみのエラーが出る。どちらのエラーが出るかはランダム。**
**①、②の両方に当てはまるような単一の Reference Image のみ場合でも、どちらか一方のエラーのみが出る。どちらになるかはランダム。**

#### 補足:

- **①、②のパターンとも、値(String)は ARKit のバージョンアップで変更される可能性があり、またパターンの増減もありえる**
- ②について、以前のバージョンのARKitでは480ピクセル必要だったらしいが、100ピクセルに変わったのだろう
- 以下の2記事によると、Reference Image のアスペクト比が 3:1 以下でなければならない（例えば 2:1 はOKだけど 5:1 はNG）とのことだが、これもおそらく以前のバージョンでだけ存在する制約だろう(もしくはより高いアスペクト比まで緩和されたのか)。私が試したところ、5:1 でもエラーは出ず問題なく動作した。
  - [ARReferenceImageの制限について -- Qiita](https://qiita.com/satoshi-baba-0823/items/472b6a3e39ea6cb98a45)
  - [ARKit画像マーカーに適した画像適さない画像 -- Qiita](https://qiita.com/k-boy/items/988af3a1663e84f2f328)

### エラー原因ファイルの特定

`arErrorInfo.errorUserInfo["ARErrorItems"]`でエラー原因となっている Reference Images のファイルパス一覧が取得できる。

私の場合では、これを解析することでファイル名を抽出し、どれに対処するべきかをユーザーに提示している。
ただし、同一ファイル名のものがある場合にはこの方法は使えないので、ファイル名が固有なことが前提となる。ちなみに私はUUIDでファイル名をつけている。

#### ファイル名の解析方法

以下のコードで、ファイル名（拡張子除く）の配列`invalidIDs`が得られる。

```swift
        // 再掲
        if let arErrorInfo: ARError = error as? ARError {
            print(arErrorInfo.errorUserInfo)
        }

       // ファイル名の解析
        var invalidIDs: Array<String> = []
        if let arErrorItems: Array<String> = arErrorInfo.errorUserInfo["ARErrorItems"] as? Array<String> {
            invalidIDs = arErrorItems.map { (filePath: String) -> String in
                filePath.components(separatedBy: "/").last!.components(separatedBy: ".").first!
            }
        }
```

例えば、

- `arErrorInfo["ARErrorItems"]`:
  - 0 : file:///var/mobile/Containers/Data/Application/A55C7B34-E1AB-4892-9160-E0287C3351C0/Documents/F5678103-A653-4C1E-9616-9EC198FEBDE6.mov
  - 1 : file:///var/mobile/Containers/Data/Application/A55C7B34-E1AB-4892-9160-E0287C3351C0/Documents/05BA2ECD-0B7A-44B8-87EB-77DB44B80B53.mov

に対して、

- `invalidIDs`:
  - 0 : F5678103-A653-4C1E-9616-9EC198FEBDE6
  - 1 : 05BA2ECD-0B7A-44B8-87EB-77DB44B80B53

が得られる。

## おわり

本記事では ARKit において Reference Image に起因するエラーについて、原因とファイルを特定する方法を紹介した。

しかし、この方法ではARセッションが実行されて初めて特定可能であり、本来ならばユーザーが Reference Image を登録した時点で特定することがより望ましい。もしその方法がわかったら追記したい。
&rArr; 冒頭に追記した
