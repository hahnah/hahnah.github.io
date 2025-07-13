---
title: "imgタグのsrc画像が取得できない場合のフォールバック方法"
# image: "/images/tech-blog/slug/image.jpg"
description: "imgタグのsrc画像が取得できない場合にフォールバックの画像を設定する方法を解説する。HTMLとReactの両方の実装方法を紹介する。"
published: "2025-07-13"
# updated: "2025-02-20"
category: "tech"
tags: ["react", "image", "cdn"]
---

## imgタグのsrc画像が取得できない場合にフォールバックしたい

そんなケースがある。  
例えば、CDNで最適化した画像を基本的に扱いたいが、CDNが障害で使えない場合にオリジン画像をS3バケットから取得したい場合などだ。

これは簡単に実装できる。

## HTMLでの実装

`img`タグの`onerror`イベントを使って、画像の取得に失敗したときにフォールバックの画像を設定する。

```html
<img
  src="https://cdn.example.com/photo.jpg"
  onerror="this.onerror=null; this.src='https://your-s3-bucket.s3.amazonaws.com/photo.jpg';"
/>
```

これは、DOMのフィールドを直接操作しているのであまり推奨されないが、簡単に実装できる。

## Reactでの実装

Reactの場合、`onerror`ではなく`onError`と書く。

srcを動的にセットし、onErrorでフォールバックのURLに切り替えるような実装だ。

```react
const ImageWithFallback = ({ src, fallbackSrc, ...props }) => {
  const [imageSrc, setImageSrc] = React.useState(src);

  return (
    <img
      src={imageSrc}
      onError={() => setImageSrc(fallbackSrc)}
      {...props}
    />
  );
};
```

使い方は以下のようになる。

```react
<ImageWithFallback
  src="https://cdn.example.com/photo.jpg"
  fallbackSrc="https://your-s3-bucket.s3.amazonaws.com/photo.jpg"
/>
```

HTMLでの実装よりは、こちらの方がいいだろう。
