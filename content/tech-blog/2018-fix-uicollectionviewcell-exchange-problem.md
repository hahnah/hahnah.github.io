---
title: "[Swift] UICollectionView でスクロールすると Cell の配置が変わる問題の対処"
# image: "/images/tech-blog/slug/image.jpg"
description: "UICollectionViewCell のチェックマークの配置がスクロールで変わる問題を解決する方法を紹介する。"
published: "2018-08-01"
updated: "2025-08-03"
category: "tech"
tags: ["swift"]
---

## 問題

[まえの記事](https://hahnah.github.io/tech-blog/2018-checkmark-on-uicollectionviewcell/) の実装で、スクロールするほど Cell が多い場合、 スクロールをすることで Cell の配置が変わってしまうという問題が実は発生する。

![問題のキャプチャ](/images/tech-blog/2018-fix-uicollectionviewcell-exchange-problem/fixed-checkmark-demo.webp)

## 修正方法を探る

CollectoinViewController の`collectionView(_:cellForItemAt:)`メソッドについて挙動を確認してみて分かったことは、

- `indexPath`の Cell が表示されるときに呼ばれる
  （作成時に呼ばれるものと勘違いしていた）
- `dequeueReusableCell`メソッドで 再利用可能な Cell を取している
  （そのままやんけ）

↓ 問題の`collectionView(_:cellForItemAt:)`メソッド

```
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CustomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CustomCell
        cell.contentView.backgroundColor = UIColor.yellow
        return cell
}
```

`dequeueReusableCell`メソッドで表示されなくなった Cell を使い回す実装になっているのだが、どうやら、Cell が前世の状態のまま使い回されるようだ。  
そのため、前世の記憶（addSubview メソッドで加えられた チェックマークの view）がそのまま残っているというわけ。

なので、前世の記憶を一旦消して、現世の`indexPath`に応じてチェックマークを付けたり付けなかったりすればよい。

## 修正概要

具体的には、`collectionView(_:cellForItemAt:) ` 内に次の処理を加えれば良い。

1. 前世の記憶を削除する

```
// 古い subview を削除
cell.contentView.subviews.forEach { subview in
		subview.removeFromSuperview()
}
```

2. `indexPath`に応じてチェックマークを付け直す

```
if CustomCell.shouldCellBeMarked(selectedItemAt: indexPath) {
		cell.mark(selectedItemAt: indexPath)
} else {
		cell.unmark(deselectedItemAt: indexPath)
}
```

該当の`indexPath`の Cell にチェックマークを付け直すかどうかを判断するには  
`indexPath`に対するチェックマーク有無を記憶しておく必要があるので、CustomCell に static 変数として用意した。

```
static var checkmarkStates: [Bool]
```

上記に合わせてその他細かな変更もあるが、それについてはソースコードを参照していただきたい。

## ソースコード

修正後のソースコードは以下のとおり。

##### CustomCell.swift

[https://gist.github.com/hahnah/ce942b0f01ce75eea2f86986d6cd4759#file-CustomCell.swift](https://gist.github.com/hahnah/ce942b0f01ce75eea2f86986d6cd4759#file-CustomCell.swift)

##### CollectionViewController.swift

[https://gist.github.com/hahnah/ce942b0f01ce75eea2f86986d6cd4759#file-CollectionViewController.swift](https://gist.github.com/hahnah/ce942b0f01ce75eea2f86986d6cd4759#file-CollectionViewController.swift)

##### ExtendedCollectionViewController.swift

掲載略

[こちらで見れます](https://gist.github.com/hahnah/ce942b0f01ce75eea2f86986d6cd4759#file-customcell-swift)
