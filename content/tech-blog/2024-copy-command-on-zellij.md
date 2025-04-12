---
title: "Zellijでコピーのショートカットをするには"
image: "/images/tech-blog/2024-copy-command-on-zellij/cover.avif"
description: "Zellijを使っている際に、どうすれば選択範囲をコピーできるのか紹介する。"
published: "2024-05-08"
updated: "2025-04-12"
category: "tech"
tags: ["cli", "zellij"]
---

Zellij 上でコピーのショートカット(Macだと「command + c」、Windowsだと「ctrl + c」のやつ)を使っても、

「ポッ」(無効ですよの音) となってコピーできてなさそうに思った。

Zellij のバージョンは 0.40.1

## どうすればいいか

結論、何もしなくてもコピーできてる。

Zellij のデフォルトの設定だと、ドラッグしただけでクリップボードにコピーされる。  
超便利じゃん。

## どうしても「command + c」じゃないとダメなんだ！という場合

そんなケースがあるのかわからないけれども、[Zellijのドキュメント](https://zellij.dev/documentation/options#copy_command) にあるように、

~/.config/zellij/config.kdl (Zellijの設定ファイル)に以下の行を書けば良い(OSに合わせてどれか1つ)。

```
copy_command "xclip -selection clipboard" // x11
copy_command "wl-copy"                    // wayland
copy_command "pbcopy"                     // osx
```

さらに、

```
copy_on_select=false
```

も書かないとダメな気がする。

これはデフォルトで `true` なんだけれど、`true` だとドラッグしたら(クリップボードにコピーされて)ドラッグがクリアされちゃうので。

デフォルトの設定ファイルだと

```
// uncomment this and adjust key if using copy_on_select=false
```

となってる箇所がいくつかあるが、その箇所も変更する必要あり。
