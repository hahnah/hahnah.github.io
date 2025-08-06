---
title: "elm-pages で作ったサイトに Google Analytics 4 を設定する方法"
# image: "/images/tech-blog/slug/image.jpg"
description: "elm-pages のサイトに Google Analytics 4 を設定するには /elm-pages.config.mjs の記述が必要です。"
published: "2025-08-06"
# updated: "2025-02-20"
category: "tech"
tags: ["elm", "elm-pages", "google-analytics"]
---

## 本記事執筆時の環境

- elm-pages 3.0.20 (npmパッケージとしてのバージョン)
- dillonkearns/elm-pages 10.2.0 (Elm Package としてのバージョン)
- Google Analytics 4 のプロパティが作成済み

## Google Analytics 4 のタグを elm-pages で作ったサイトに埋め込む方法

elm-pages を使ったサイトのソースコードに、`/elm-pages.config.mjs` を作成し、以下の内容を記述します。  
これはソースコードのルートに置きます。

```javascript
import { defineConfig } from "vite";

export default {
  vite: defineConfig({}),
  headTagsTemplate(context) {
    return `
<link rel="stylesheet" href="/style.css" />
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
`;
  },
  preloadTagForFile(file) {
    return !file.endsWith(".css");
  },
};
```

`G-XXXXXXXXXX` の部分2箇所は、Google Analytics 4 の測定IDに置き換えてください。

これでうまくいきます。

## 補足

`script' タグの設置には今回のように `elm-pages.config.mjs` への記述が必要です。
