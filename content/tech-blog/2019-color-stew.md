---
title: "Color Stew で簡単カラースキーム作成"
image: "/images/tech-blog/2019-color-stew/color-stew-screen.avif"
description: 'カラースキーマの理論に基づいた美しいカラーパレットを簡単に作成できるWebアプリ "Color Stew" を開発した。'
published: "2019-08-03"
updated: "2025-03-26"
category: "tech"
tags: ["color-stew", "indie-app", "design", "color-theory", "elm"]
---

以下のURLから利用できる。  
[https://hahnah.github.io/color-stew](https://hahnah.github.io/color-stew)

## Color Stew の概要

私はアプリ画面のデザインにおいて、配色が苦手だ（配色以外も苦手だが&#x1f616;）。使いたい色は思い浮かぶのだが、それに合う色がわからない。カラースキームをうまく作れないのだ。

そんな私のような人のための、カラースキーム作成の助けになるアプリが **Color Stew** だ。

あなたが使いたい色をひとつ選ぶと、Color Stew はそれをベースにしてカラースキームを自動で生成してくれる。このとき、Color Stew は _Monochromatic_ や _Dyad_ などの配色技法に基づいて11種類のカラースキームを提示してくれる。

Color Stew のページの一部は、あなたが選択したカラースキームで配色される。  
そのカラースキームでどのような見栄えになるのかを、すぐに確認できるというわけだ。

自動生成されたカラースキームがダサくて使えないなんてこともあるだろう。でも心配は無用！  
彩度と明度を調整したり、色の割り当て箇所を変更したりすることで、きっとクールなカラースキームが見つかるはずだ！！

## 使い方

1. **ベースカラーを選択する**
   ベースカラーを選択すると自動的にカラースキームが作成される。
2. **カラースキームを選択する**
   選択したカラースキームがどのように見えるか、画面右のプレビューに反映される。
3. **プレビューを確認しながら色を調整する**
   - 彩度を調整する
   - 明度を調整する
   - 色の配置を変える

![usage](/images/tech-blog/2019-color-stew/color-stew-usage.avif)

**NOTE:** Color Stew はPCでの利用を推奨。スマートフォンだとうまく操作できないと思う。

## ソースコード

Color Stew のソースコードは MITライセンスのもと GitHub で公開している。開発に使った言語は Elm だ。  
[https://github.com/hahnah/color-stew](https://github.com/hahnah/color-stew)

以下の記事で実装についても少しだけ説明している。  
[https://hahnah.github.io/tech-blob/2019-color-stew-technology](https://hahnah.github.io/tech-blob/2019-color-stew-technology)
