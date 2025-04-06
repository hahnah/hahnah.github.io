---
title: "ARKitを使ったアプリ開発時に気にかけたこと"
image: "/images/tech-blog/2019-arkit-dev-knowledge/cover.avif"
description: "ARKit を使ってアプリを作ったので、それに際し気にかけたことやノウハウを雑にまとめておく。"
published: "2019-07-02"
updated: "2025-04-06"
category: "tech"
tags: ["ar-photoplay", "ar", "ios", "swift", "arkit"]
status: "draft"
---

## 制作物概要

こちらの記事にある **AR Photoplay** というアプリを作った。

https://superhahnah.com/ar-photopay/

簡単にいうと、

1. 動画を撮って、実物の写真としてプリントする
   (写真を部屋に飾ったりしよう！）
2. 写真にiPhoneをかざす
   &rArr; 写真が画像認識され、写真の位置に動画が再生される!

ってアプリ。  
画像認識してそこに動画を表示する、という部分でARKitを利用している。

## 環境情報

- XCode 10.2.1
- Swift 5.0
- ARKit 2.0
- iOS 12.2

## 気にかけたこと

ARアプリを作る上で、もしくは ARKit で画像認識する際に気にかけた方が良さそうと思ったことや、自分の行った工夫などを書き連ねていく。

### ユーザーとAR空間のインターフェース領域を広くとる

スマートフォン用のARといえば、カメラを使うことになる。  
カメラプレビュー上にARコンテンツを合成表示することでARエクスペリエンスを提供する(この画面がユーザーとAR空間のインターフェースになる)。ここで没入感を邪魔しないためには、**プレビュー画面を広く取り、障害物となるUIをなるべく表示しない**ことが大事になると思う。画面の上下にナビゲーションバーやツールバーなどを表示していると、それだけで画面が狭くなったり、視界が遮られたりしてしまい、没入感が下がってしまう。

私の作成した AR Photoplay のアプリでは AR用の画面上からなるべくUIを減らせるように考慮してアプリ全体の画面と遷移を設計している。AR用の画面上に唯一ナビゲーションバーを表示しているが、**無色透明の背景に白色の文字**にすることでなるべくARエクスペリエンスの邪魔にならないよう工夫した。

↓がその画面のスクショ。左上に「**<** **Favorites**」 とあるのが前の画面に戻るためのUI。白文字が目立ち過ぎず、目立たなさ過ぎなず丁度良いと思う。

![AR Photoplay](/images/tech-blog/2019-arkit-dev-knowledge/ar-photoplay.avif)

### カメラの動きに対するarコンテンツの追従性能

arkit でarコンテンツを表示するときは、次のどちらかを利用することになる:

- [arworldtrackingconfiguration](https://developer.apple.com/documentation/arkit/arworldtrackingconfiguration)
- [arimagetrackingconfiguration](https://developer.apple.com/documentation/arkit/arimagetrackingconfiguration)

以下の違いがある (使用感については実際に自分で試している):

- `arworldtrackingconfiguration`
  - ios 11.0+ の端末で利用可能 (arkit 1.0 からの機能)。ただし画像認識の機能は ios 11.3+ の端末で利用可能 (arkit 1.5 からの機能)。
  - 現実世界をスキャンして平面を認識し、平面に紐づけてarコンテンツを配置するような、多くのarアプリで必要とされる用途に使える。また、認識した平面上から画像を認識して、そこに紐づけたarコンテンツ配置も可能 (画像認識は arkit 1.5 からの機能)。
  - コンテンツがar空間に一度配置されると、画面外になっても存在しつづける (画像認識機能だと違ったかも？試したんだけど忘れた)。リッチなarエクスペリエンスに向いている。
  - **画像検出の機能を使った場合は、検出位置・向きの更新が遅く、arコンテンツの追従に明らかにラグが出る。0.5秒以下程度の間隔でコンテンツ表示位置がカメラ/検出画像の動きに追従するような感じ。iphoneをゆっくり動かしただけでもはっきりとラグが感じらる。**
- `arimagetrackingconfiguration`
  - ios 12.0+ の端末で利用可能 (arkit 2.0 からの機能)
  - 現実世界の平面認識はしておらず、画像認識・トラッキングして認識箇所に紐づけてarコンテンツを配置する。
  - 配置されたコンテンツは画面外になると存在しなくなる。
  - **コンテンツ表示位置がリアルタイムに更新される。iphoneを素早く動かしたとしてもラグはほとんど感じられない。**

機能面では前者の`arworldtrackingconfiguration`が優れているのだが、画像認識に限定すると性能面では後者の`arimagetrackingconfiguration`が優れている。

今回制作したアプリでは、機能的には画像認識があればよいので前者後者どちらでも可だが、性能的には後者が優れていることから`arimagetrackingconfiguration`を選択した。

ちなみに、デバイスのosバージョンに応じて使い分けるといった手も可能だ; ios 12.0 未満なら`arworldtrackingconfiguration`を、ios12.0 以上なら`arimagetrackingconfiguration`で対応できる。  
しかし私は、使い勝手が悪いものをそもそも使わせたくなかったので、思い切って ios 12.0+ のみを対象として`arworldtrackingconfiguration`のみの採用とした。

### 認識対象とする画像の物理サイズについて

ARKitで画像認識の機能を利用する場合、[ARReferenceImage.physicalSize](https://developer.apple.com/documentation/arkit/arreferenceimage/2941027-physicalsize) に、現実世界における認識対象の縦横の大きさを指定する必要がある。

この値は適当でも意外と大丈夫だが、実物との差があまりにも大きすぎると動画の表示が点滅するようになってしまった(認識がうまくいったり行かなかったりを短時間に繰り返す)。写真のサイズはある程度決まってるので（L版が最も一般的）、それに大体合わせた。壁一面を埋める程に大きなの写真だと上手くいかないかもしれないが、ほとんどのケースでは問題は起こらないだろう。  
ユーザーに厳密な値を入力してもらうという手段をとれば、大小様々なサイズに対して安定して動作させられるのだが、それを入力させるのはユーザーにとって相当面倒だろうと思い、今回は`physicalSize`は固定値でで済ませた。

(この文章を書きながら今更気づいたが、先の固定値をデフォルト値としておいて、必要に応じてユーザーが`physicalSize`を設定できるようにするのが良さそうだ。)

#### 余談: 物理サイズの推定

記事執筆時点では Beta 機能なのだが、iOS 13.0+ (ARKit 3.0 からの機能) では`ARWorldTrackingConfiguration`の [automaticImageScaleEstimationEnabled](https://developer.apple.com/documentation/arkit/arworldtrackingconfiguration/3075551-automaticimagescaleestimationena) プロパティによって画像の物理サイズを推定させることができ、大小様々な画像を安定して認識させられるようになりそう。  
ただし`ARImageTrackingConfiguration`には実装されない機能なので、私が **AR Photoplay** のアプリで使うことはなさそう。

### 認識対象とする画像の枚数について

ARKit のドキュメントによると、画像認識の正確さと性能を高く保つためには、約25枚以下の画像セットとするのが良いようだ。

> Image detection accuracy and performance are reduced with larger numbers of detection images. For best results, use no more than around 25 images in this set.
> (https://developer.apple.com/documentation/arkit/arworldtrackingconfiguration/2941063-detectionimages](https://developer.apple.com/documentation/arkit/arworldtrackingconfiguration/2941063-detectionimages)
> より)

上記は`ARImageTrackingConfiguration`のドキュメント中の記載だが、`ARImageTrackingConfiguration`の方ではこれについて触れられていなかった。
もしかしたら、`ARImageTrackingConfiguration`ではこれより枚数を増やしても問題ないかもしれない。`ARImageTrackingConfiguration`の方が元々パフォーマンスが出やすいので、少なくとも性能の観点からは25枚以上で問題ないと言えるだろう。しかし、正確さの観点からはどうなんだろうか？ わからない。

**AR Photoplay** のアプリにおいては、ユーザーが複数のアルバム(アプリ内では**ポートフォリオ**と呼んでいる)を作成できるようにし、１アルバムごとに 24コンテンツ を保存できるようにした(アルバム内のコンテンツ数==認識画像数)。アルバムを切り替えると認識画像セットも切り替わる。
25 でなく 24 にしたのは、&darr; の画像のようにUICollectionView で 3xN に表示した際にキリが良いから (3の倍数だから)。

![album](/images/tech-blog/2019-arkit-dev-knowledge/item-collection.avif)

### 画像認識に使えないエラー画像の扱い

ARKitでの画像認識に使えない画像が認識画像セットに含まれていた場合、ARセッションの実行中にランタイムエラーが発生し、ユーザーはAR機能が使えないか、最悪アプリがクラッシュする。この状況はなんとしても回避しなければならない。そのためにも、画像認識に使えない画像を検知する必要がある。

ある画像がARKitでの画像認識に使えるかどうか、というのを調べる方法は大きく2通りある:

- assetとしてアプリにバンドルする場合: 使えない画像とその理由を Xcode が警告してくれる
- 〃 しない場合(ユーザーが決める場合): プログラムでチェックしなければならない

**AR Photoplay** のアプリでは、ユーザーが保存した動画から最初の1フレームを画像化し、それを認識画像としている。  
つまり、認識画像はユーザー依存なので、画像認識に使えるかどうかはプログラムでチェックしなければならない。

**AR Photoplay** のアプリでは、ARセッション実行時のランタイムエラーを拾い（アプリはクラッシュさせない）、エラー内容を解析して原因となっているコンテンツとエラーの理由を特定している。  
その詳細な方法は以下の記事にまとめた。

https://superhahnah.com/arkit-invalid-reference-image/

エラーのあるコンテンツとその理由をユーザーに提示し、エラーを取り除くための対処を促すようにしている(↓画像)。

| ![suggestion for imvalid image](/images/tech-blog/2019-arkit-dev-knowledge/arphotoplay-suggestion-for-invalid-image.avif) | ![invalid image icon](/images/tech-blog/2019-arkit-dev-knowledge/arphotoplay-invalid-image-icon.avif) |
| ------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |

### ポラロイドのような正方形の写真/動画

これは ARKit とは直接関係ない話だが、**AR Photoplay** は動画を撮影する機能を持っている。

**AR Photoplay** では、コンテンツを選択して写真を印刷する機能があるのだが(プリンターは別途必要)、普通の写真だけでなく正方形のポラロイド風のものもオシャレでいいなと思った。  
というわけで、正方形の動画を撮影できるような機能を実装した。ついでに、縦横さまざまな長方形にも対応させた。

&darr; のように、撮影するサイズを自由に選べるようになっている。

![screen capture](/images/tech-blog/2019-arkit-dev-knowledge/screencapture.webp)

この動画のアスペクト比がそのまま認識画像のアスペクト比になるわけだが、ARKitにおける認識画像には**3:1 以下の制約がある（?）**。ただ、この制限は ARKit 1.0 のときのものと思われる。5:1 で試しても ARKit 2.0 ではエラーにならなかった。

あまりアスペクト比を大きくしすぎると **100px x 100px 以上** という認識画像の別の制約を満たさなくなることもあって、とりあえず 3:1 までにした。

#### 余談

この撮影機能は単体でも使えそうだと思ったので、ライブラリ化した。[FlexibleAVCapture - CocoaPods](https://cocoapods.org/pods/FlexibleAVCapture)

https://superhahnah.com/swift-flexibleavcapture/

このライブラリの利用例を示すため(と自分が使うため)に、オープンソースなアプリも作った。

https://superhahnah.com/flex-camera/

#### おわり
