---
title: "Unfair Roulette : インチキできるルーレットアプリを作成した"
image: "/images/tech-blog/2018-unfair-roulette/unfair-roulette.avif"
description: "ルーレットの止まる目を操作することができる、そんなルーレットだ。悪事や人を傷つけることには使わないこと。"
published: "2018-11-18"
updated: "2025-04-03"
category: "tech"
tags: ["unfair-roulette", "indie-app"]
---

こちらのリンクから利用できる。  
[https://hahnah.github.io/unfair-roulette/](https://hahnah.github.io/unfair-roulette/)

### 特徴

もちろん公正な普通のルーレットとして利用することができる。  
ただしそれだけでなく、**ルーレットの止まる目を操作する**こともできる。

以下の利用例にて詳しく説明する。

## 利用例

### フェアな使い方

複数人で意見が別れたとき、多数決ではなく票数に比例した確率で決定するような、公平な方法がルーレットによりもたらされる。

```
あなた 「ねえみんな、ご飯どこにする？　おいしいインドカレー屋さんがあるんだけど、どうかな?」
Aさん 「カレーもいいけど、私はパスタが食べたいな〜」
Bさん 「パスタいいね！ 自分もパスタ食べたい」
Cさん 「何でもいいけど、しいて言えば中華の気分」
あなた 「じゃあ、ルーレットで決めようか」
```

この場合、  
インドカレー : パスタ : 中華 = 1 : 2: 1  
となる以下のようなルーレットによって、票の比率に応じた公平な決定ができる。

![fair-case](/images/tech-blog/2018-unfair-roulette/fair-case.avif)

&dArr;

![fair-result](/images/tech-blog/2018-unfair-roulette/fair-result.avif)

### アンフェアな使い方

ルーレットによって公平な方法で決定する。

と見せかけて、自分の好きなものに決定することができる。

```
あなた 「ねえみんな、ご飯どこにする？　おいしいインドカレー屋さんがあるんだけど、どうかな?」
(中略)
あなた 「じゃあ、ルーレットで決めようか (￣ー￣)ﾆﾔﾘ」
```

![unfair-case](/images/tech-blog/2018-unfair-roulette/unfair-case.avif)

&dArr;

![unfair-result](/images/tech-blog/2018-unfair-roulette/unfair-result.avif)

## ソースコード

[https://github.com/hahnah/unfair-roulette/tree/1.0.0](https://github.com/hahnah/unfair-roulette/tree/1.0.0)
