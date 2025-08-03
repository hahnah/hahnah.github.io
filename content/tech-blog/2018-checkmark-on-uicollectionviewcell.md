---
title: "[Swift] UICollectionViewCell にチェックマークをつける"
# image: "/images/tech-blog/slug/image.jpg"
description: "UICollectionViewCell にチェックマークをつける方法を紹介する。iOS標準の写真アプリのように、選択された Cell にチェックマークを表示することができる。"
published: "2018-07-30"
updated: "2025-08-03"
category: "tech"
tags: ["swift"]
---

※この記事には補足の記事があります:  
[Swift – UICollectionView でスクロールすると Cell の配置が変わる問題の対処](https://hahnah.github.io/tech-blog/2018-fix-uicollectionviewcell-exchange-problem/)

CollectionView の Cell を複数選択する際、 iOS標準の写真アプリだと  
選択された Cell にはチェックマークが表示される。

それと同じようなことを実現したくてコードを書いてみた。

↓完成図
![完成キャプチャ](/images/tech-blog/2018-checkmark-on-uicollectionviewcell/checkmark-demo.webp)

## CustomCell を定義する

まず、UICollectionView を継承して CustomCell を作る。

CustomCell ではシンプルに、以下の２つのことだけを意識している。

- Cell が選択状態になる &rArr; チェックマークの View を追加する
- Cell が解除状態になる &rArr; チェックマークの View を削除する

[https://gist.github.com/hahnah/2b3f0f373562e1cdc80740b7e0ff5d47#file-CustomCell.swift](https://gist.github.com/hahnah/2b3f0f373562e1cdc80740b7e0ff5d47#file-CustomCell.swift)

## CustomCell を利用する

CollectionView の Cell として 上記で定義した CustomCell を使う。

ポイントは、

- CustomCell を UICollectionView オブジェクト の Cell として登録すること （33行目）
- Cell 選択時に呼び出される関数（56行目） で CustomCell.isMarked を true にすること
- Cell 選択解除時に呼び出される関数（64行目） で CustomCell.isMarked を false にすること

[https://gist.github.com/hahnah/2b3f0f373562e1cdc80740b7e0ff5d47#file-CollectionViewController.swift](https://gist.github.com/hahnah/2b3f0f373562e1cdc80740b7e0ff5d47#file-CollectionViewController.swift)

## おまけ: 複数選択の開始/キャンセル

複数選択を開始する用ボタンをタスクバーにつけたバージョンも作った。

![複数選択開始ボタンをつけたバージョン](/images/tech-blog/2018-checkmark-on-uicollectionviewcell/checkmark-demo2.gif)

タスクバーを用意して、Select / Cancel ボタンで 複数選択モードと そうでないモードを切り替えるように実装している。

複数選択モードのときだけチェックボックスが出て、 Cancel ボタンが押されるとチェックマークはすべて消える。

[https://gist.github.com/hahnah/2b3f0f373562e1cdc80740b7e0ff5d47#file-ExtendedCollectionViewController.swift](https://gist.github.com/hahnah/2b3f0f373562e1cdc80740b7e0ff5d47#file-ExtendedCollectionViewController.swift)
