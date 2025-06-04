---
title: "[Web] Retina 等の HiDPI ディスプレイで画像が粗くみえてしまわないように"
# image: "/images/tech-blog/2021-web-images-for-hidpr/dpr-2.avif"
description: "近年ではPCもスマートフォンも、HiDPIのディスプレイが当たり前になってきた。Webページに画像を表示する際、HiDPIディスプレイで粗く見えないようにするための方法を紹介する。"
published: "2021-02-02"
updated: "2025-06-03"
category: "tech"
tags: ["frontend", "image"]
---

## 左の画像、粗く見えませんか？

Webページに画像を表示した際、表示サイズと同等の解像度を持つ画像を用意したとする。このとき、画像が粗く見えてしまうことがある。

次の ピサの斜塔 の画像を Retina Display で見比べると、左の画像の方が粗く、右の方が精細に見えているはずだ。

| 300px幅の画像を300px幅で表示                                                                                    | 600px幅の画像を300px幅で表示                                                                                    |
| --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| ![300px幅の画像を300px幅で表示](/images/tech-blog/2021-web-images-for-hidpr/pisa-300.avif#width=300&height=400) | ![600px幅の画像を300px幅で表示](/images/tech-blog/2021-web-images-for-hidpr/pisa-600.avif#width=300&height=400) |

左では

```html
<img src="image-300.jpeg" width="300" height="400" />
```

のようにして、画像解像度と同じ解像度で表示している。
(`image-300.jepg`は横幅が300px の画像)

右では

```html
<img src="image-600.jpeg" width="300" height="400" />
```

のように、画像解像度が２倍(横幅でいうと600pxある)となっているが表示サイズは左側と同じだ。  
(`image-600.jepg`は横幅が600px の画像)

**「どちらも300px幅で表示してるんだから、ソース画像が300px幅以上であれば同等の精細さに見えないとおかしいだろ！！」**  
と思うかもしれないが、そうではない。

これには **Device Pixel Ratio** というものが関係しており、 Device Pixel Ratio に対して画像の解像度と表示サイズが適切でないことで起こってしまう。

この記事では Device Pixel Ratio が何なのか、画像表示にどう影響してくるのかを説明し、冒頭の問題に対処するための方法を紹介する。

## Device Pixel Ratio (DPR) とは

Device Pixel Ratio (略称 DPR) は、CSSピクセルに対するデバイスピクセルの比を意味する。  
(あるいは、CSS解像度に対する物理解像度の比とも表現できる。)

`DPR = Device Pixel / CSS Pixel`

簡単に言うと、CSS上の1pxが物理ピクセルいくつで表示されているかという値だ。  
DPR が 2 の場合には下図の様になっている。

![DPR:2](/images/tech-blog/2021-web-images-for-hidpr/dpr-2.avif)

MacBook や iPhone に搭載されている Retina Display など、近年は DPI (Dots Per Inch) の高いディスプレイが普及している。

しかしそのようなディスプレイでは Web のシーンにおいて DPR が高くなり、冒頭の例のように画像が粗く見えてしまうことがある。

## DPRに対して適切な画像の表示サイズ・解像度はいくつか

単に高解像度の画像を配信すれば、DPRが高いデバイスで画像が粗く見える問題は解決する。  
しかし、それではDPRが低いデバイスにとっては画像の解像度が必要以上に大きい。画像のファイルサイズが大きくなる分、ダウンロードに時間がかかってパフォーマンスが低くなってしまうのだ。

故に、単に高解像度の画像を使うのではなく、DPRに応じて必要十分な解像度の画像を用意するのが望ましい。

CSS上での300pxで画像を表示したいならば、

- DPR が 1 ならば 300px の画像
- DPR が 2 ならば 600px の画像
- DPR が 3 ならば 900px の画像

をそれぞれ用意するのが適切だ。

## DPR に応じて画像を出し分ける方法

DPR によって適切な画像解像度が異なるという問題は、様々な解像度の画像を用意しておき DPR に応じて出し分けることで解決できる。

これには `srcset` プロパティで `1x`, `1.5x`, `2x`, `3x` といったような **ピクセル密度デスクリプタ** を利用する。

DPRが 1, 2, 3 の場合を考慮した書き方がこちら:

```html
<img
  src="image-300.jpeg"
  srcset="image-600.jpeg 2x, image-900.jpeg 3x"
  width="300"
  height="400"
/>
```

## 開発時に Chrome DevTools で DPR を設定する方法

DPRに応じた出し分けが機能しているかどうか確認するには、 Chrome DevTools を使うと便利だ。以下の方法で利用できる。

1. Chrome DevTools を開いて、`Toggle device toolbar` を ON にする
   ![toggle toolbar](/images/tech-blog/2021-web-images-for-hidpr/toggle-toolbar.avif)
2. ケバブメニュー(縦にドットが3つ並んでるやつ)から `Add device pixel ratio` をクリックする
   ![add-dpr](/images/tech-blog/2021-web-images-for-hidpr/add-dpr.avif)
3. DPRを設定できるようになるので、お好きなDPRにして表示を確認
   ![select-dpr](/images/tech-blog/2021-web-images-for-hidpr/select-dpr.avif)

## デバイスの DPR を JavaScript で取得する方法

DPRに応じてJavaScriptで何かを制御したいケースがあるかもしれない。  
そんなときに DPR を取得する方法がこちら。

```js
dpr = window.devicePixelRatio;
```

[Window.devicePixelRatio -- MDN Web Docs](https://developer.mozilla.org/ja/docs/Web/API/Window/devicePixelRatio) に以下の使用例が紹介されている。

- `<canvas>` の解像度を補正する
- 画面解像度やズームレベルの変化を監視する

## 参考

- [レスポンシブイメージのネイティブサポート -- HTML5 Rocks](https://www.html5rocks.com/ja/tutorials/responsive/picture-element/)
- [レスポンシブ画像 -- MDN Web Docks](https://developer.mozilla.org/ja/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images#resolution_switching_same_size_different_resolutions)
- [Window.devicePixelRatio -- MDN Web Doks](https://developer.mozilla.org/ja/docs/Web/API/Window/devicePixelRatio)
- [いまさら聞けないRetina対応のための「ピクセル」の話](https://parashuto.com/rriver/development/pixel-related-info-for-coping-with-retina-displays)
