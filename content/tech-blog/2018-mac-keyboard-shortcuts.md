---
title: "Mac のエディタ作業効率を上げるショートカット集"
# image: "/images/tech-blog/slug/image.jpg"
description: "Mac のエディタでよく使うキーボードショートカットをまとめました。カーソル移動やコピー・ペーストなど、作業効率を上げるための便利なショートカットです。"
published: "2018-07-29"
updated: "2025-08-03"
category: "tech"
tags: ["macos"]
---

私がエディタ利用時によく使うキーボードショートカットをまとめました。

ちなみに、エディタ以外でもテキストを編集するシーンであれば使えます。

## カーソル移動系

指がホームポジションからあまり動かずに済むので  
普通にカーソルキーを使うよりも、圧倒的に楽で早いです。

慣れるまで戸惑うかもしれませんが、ぜひ覚えておきたいキーボードショートカットです。

- control + f : 1文字進む (forward)
- control + b : 1文字戻る (backward)
- control + p : 1行上へ (previous line)
- control + n : 1行下へ (next line)
- control + a : 行の先頭へ (アルファベットの1文字目)
- control + e : 行の末尾へ (end)

## コピー、ペースト系

- shift + カーソル移動 : 範囲選択
  - NOTE: Shift + カーソル移動系ショートカット でもOK
- command + c : 選択範囲をコピー
- command + x : 選択範囲をカット
- command + v : ペースト
- control + h : 左側の1文字を削除
  - NOTE: delete キーと同じ
- control + d : 右側の1文字を削除 (delete)
- control + k : 行末尾までを削除 (kill)
  - NOTE: control + a → contorol + k とすることで1行削除できる
- control + y : ペースト その2 (yank)
  - NOTE: control + k で削除された文字列をペーストする

## Undo, Redo

- command + z : 直前の操作を取り消す
- shift + command + z : 直前に取り消した操作をやり直す

## 参考

Apple公式ページに他にも便利なショートカットが多数載っています。  
もっと知りたい方は見てみては？

[Macのキーボードショートカット(公式)](https://support.apple.com/ja-jp/HT201236)
