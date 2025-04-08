---
title: "Elm + Google Tag Manager でWebアプリケーションがフリーズして困ったんだが"
# image: "/images/tech-blog/slug/image.jpg"
description: "GTMやブラウザ拡張によって引き起こされるElmアプリケーションのフリーズについて、原因と対処方法を紹介する。"
published: "2024-11-09"
updated: "2025-04-08"
category: "tech"
tags:
  ["elm", "google-tag-manager", "browser-extension", "javascript", "typescript"]
---

## Elmなのにランタイムエラーでアプリがフリーズ

時々なんだけれども、Elmアプリケーションが完全にフリーズして、エラーが出ることがあって悩まされていた。

画面を操作しても一切動かない。

リロードしたら直る。

発生したりしなかったりする。

ブラウザのログには次のエラーが発生している。  
`Uncaught TypeError: Cannot read properties of undefined (reading 'childNodes')`

発生当時は本当に謎だった。

一応環境情報として:

- Elm 0.19.1
- elm-spa 6.x

## 現象が発生する時、しない時

発生したりしなかったりするが、どういう時に発生するのか？  
これを見極めるのは少し苦労した。

発生する時には、必ず `<body>`直下に`<iframe>`のノードがあった。  
そうでない時には発生しなかった。  
`<body>`配下の2番目や、最後に`<iframe>`がある時は問題なかった。

![フリーズする時のDOMツリー](/images/tech-blog/2024-elm-app-freezed-with-gtm/iframed-elm.avif)

この`<iframe>`はGoogle Tag Manager (GTM) により、後から挿入されているものだった。

私が担当する当該プロダクトでは、GTMにより様々なタグを設定して、動的にタグが挿入されるようにしている(例えばGoogle Analytics のタグとかね)。

稀に、GTMが `<body>`直下に`<iframe>`を挿入している。毎回ではない。

どの Google Tag がこの問題を起こしやすいのかも調査してみて、Google Adwards が発生させやすいということもわかった。

最初はその Google Tag を無効化してみた。

問題の発生はかなり収まったが、それでも少しはあった。こういった挙動をするものは色々あるんだろう。  
根本的な対策が必要だ。

## なぜこの問題が発生するか

Elmを使うと**基本的に** `<body>`直下にElmアプリケーション用のノードが作成される。  
`<body>`直下にElm用のノードがあるものとして、Elmアプリケーションを動作させるための処理が動くようになっている。

GTMやブラウザ拡張機能のJavaScriptによって、`<body>`直下に別のノードが後から挿入されることがある。  
そうすると、「`<body>`直下のノードは Elm Runtime が管轄してるノードだ」という前提が崩れ、Elmアプリケーションを動作させるための処理でエラーが発生する。

画面の更新処理もされなくなるので、操作しても画面全く動かないという最悪なユーザー体験になる。

### Elm アプリケーションでも発生しないものもある

先に

> Elmアプリケーションでは**基本的に** `<body>`直下にElmアプリケーション用のノードを作成される。

といったのは、実用ケースではほとんどそうだが例外もあるからだ。

`Browser.sandbox`, `element` を使っている場合は、HTML中のElmアプリケーション用のノードを、初期化時の`node` オプションで指定できるので、この問題は起こらない。

`Browser.document`, または `application` を使う場合は `node` の指定ができず、`<body>`直下のノードをElmアプリケーションにするし、そうなっている前提で動作するので本記事で扱っている問題が起こる。

## 解決するには

解決するには、Elmのノードが`<body>`直下にある状態を維持できればよい。

そのために、`<body>`直下に別のノードが挿入されていないかを少しの時間監視して、そうなっていたらElmのノードを`<body>`直下に移動させる。

具体的には以下のようにして解決できる。

- Elmアプリケーションのノードに識別用の属性がつける(`id="elm-node"`など)
- 次のJavaScriptで、ノードを追加するような変更がないか監視し、必要に応じてElmのノードが一番上に来るようにする

```javascript
const observer = new MutationObserver((mutations) => {
  mutations.forEach((mutation) => {
    // ノードの追加がされたかをチェック
    if (mutation.type === "childList" && mutation.addedNodes.length > 0) {
      mutation.addedNodes.forEach(() => {
        // body直下がElmのノード以外のものになっていないかをチェック
        if (
          !!document.body.firstElementChild &&
          document.body.firstElementChild.id !== "elm-node"
        ) {
          const elmNode = document.getElementById("elm-node");
          if (!!elmNode) {
            // Elmのノードをbody直下へ移動させる
            document.body.insertBefore(
              elmNode,
              document.body.firstElementChild,
            );
          }
        }
      });
    }
  });
});

//監視の開始
observer.observe(document.body, { childList: true });

// 一定時間後に監視を停止
setTimeout(() => {
  observer.disconnect();
}, 3000);
```

## おわりに

プロダクション運用でGTMを導入することはよくあることだし、本記事で扱った問題にはそれなりに遭遇するのではないだろうか。

同じように困った誰かの助けになれれば幸いだ。

それから、Elm自体に自分の管轄するノードを厳密に把握しておいてほしいとも思う。
