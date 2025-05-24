---
title: "高階関数、カリー化、部分適用からパイプライン演算子までを理解する"
# image: "/images/tech-blog/slug/image.jpg"
description: "Description are shwon below the image"
published: "2022-04-13"
updated: "2025-05-24"
category: "tech"
tags: ["functional-programming", "javascript", "elm"]
---

## 高階関数

高階関数は次の1つ以上を満たすような関数のことをいう

- 関数を引数に取る
- 関数を返す

### 関数を引数に取るような関数

※サンプルコードは基本的にJavaScript。後半にはElmも登場する。

次の`f`は高階関数。

**JavaScript**

```js
const f = function (g) {
  return g(12);
};

const square = function (x) {
  return x ** 2; // xの2乗
};

f(squre);
// => squre(12) つまり 144
```

### 関数を返すような関数

次の`f`も高階関数。

**JavaScript**

```js
const f = function (a, b) {
  return function (c) {
    return (a + b) * c;
  };
};

f(3, 4);
// => function(c) { return 7 * c }
```

### 関数を引数に取り関数を返すような関数

両方の条件を満たす関数、つまり「関数を引数にとり関数を返すような関数」も高階関数だ。

**JavaScript**

```js
const f = function (g) {
  return function (a, b) {
    return g(a, b);
  };
};

const sum = function (x, y) {
  return x + y;
};

f(sum);
// => function(a, b) { sum(x, y) }

f(sum)(5, 6);
// => 11
```

## カリー化

カリー化とは、複数引数の関数を1引数ずつ受け取るような関数にすること。
カリー化された関数は、複数の引数を受け取る代わりに常にちょうど１つの引数を受け取る。
`f(a, b, c)` という風に使われる 3引数関数は、カリー化されると`f(a)(b)(c)`のように使われる。

**JavaScript**

```js
// 高階関数の例で登場した関数f。これはカリー化されていない
const f = function (g) {
  return function (a, b) {
    return g(a, b);
  };
};

f(Math.max)(7, -8);
// => 7

// fと似ているが、こちらはカリー化されたもの
const curriedF = function (g) {
  return function (a) {
    return function (b) {
      return g(a, b);
    };
  };
};

// カリー化された関数には引数を一つずつ与えていく
curriedF(Math.max)(7)(-8);
// => 7

// ちなみに curriedF は アロー関数式を使ってこんな風にも書ける
const curriedF2 = (g) => (a) => (b) => g(a, b);
```

カリー化のいったい何が嬉しいのか？
カリー化された関数ではこの後に紹介する部分的用が簡単にでき、簡潔にコードを書ける。

#### (ちょっと寄り道)

関数がデフォルトでカリー化されているようなプログラミング言語も存在する（Elm, Haskell, F# など）。

例えばElmでは上記のサンプルコードにある関数`f`相当のもの次のように書く。
※わかりやすくするために`Int`型(整数)を扱うものとしている

**Elm**

```elm
{-| このブロックははコメント。最初の行は関数fの型を表す。(「f: (Int -> Int ... 」の部分)
	fの型について読み解くと:
		• fの第1引数は「Int型の値を2つ受け取ってInt型の値を返すような関数」
		• fの第2、第3引数は「Int型の値」
		• fの返り値は「Int型の値」
	「f g a b = g a b」が関数fの中身。fは3つの引数 g, a, b を受け取って「gにaとbを引数として与えた結果」を返す
-}
f : (Int -> Int -> Int) -> Int -> Int -> Int
f g a b = g a b

-- 関数fを使うときは、次のようにする。Elmでは引数に()は不要
f max 7 -8
```

## 部分的用

関数に一部の引数のみを適用することを部分適用という。
関数の一部の引数についてだけ固定した別の関数を作ることとも言える。

部分適用のメリットを理解するために次の例を見ていく。

例えば、ユーザーが受信したメッセージを整形して表示する関数`showMessage`があるとする。

**JavaScript**

```js
const showMessage = function (messagePresenter) {
  return function (fromWho) {
    return function (message) {
      messegePresenter(fromWho + ": " + message);
    };
  };
};

showMessage(alert)("Hahnah")("ごきげんよう！");
// => alert('Hahnah: ごきげんよう！')
```

`showMessage`はカリー化されており、引数`messagePresenter`で受け取った関数によってメッセージを表示する。
`fromWho`(メッセージの送信者名) と`message`(メッセージ本文) を組み合わせて表示文字列を作成し、`messagePresenter`で表示している。

続いて、システムからのメッセージを表示したいケースを想定してみる。
システムからのメッセージは`alert`関数で表示するものとし、送信者名は`'システム'`で固定されるものとしよう。
そんな時は部分適用をすることで次のようにシステムメッセージ用の関数`showSystemMessage`を得られる。

```js
const showSystemMessage = showMessage(alert)("システム");

showSystemMessage("ようこそ");
showSystemMessage("まずはアカウント登録をしましょう");
showSystemMessage("アカウント登録が完了しました！");
```

システムメッセージの表示には`showSystemMessage`を使い回せばよく、コードも読みやすくなる。

## パイプライン演算子

Elmなどのプログラミング言語では、パイプライン演算子(`|>`)を使って処理を簡潔に書けたりする。

いきなりだがサンプルコードを見てみよう。
関数`func1`, `func2`, `func3`があり、次のようにある値`a`に対して func1, 2, 3 の順に関数を処理していく場合、次のように書ける。

**※この章のサンプルコードはElm**

```elm
func3 (func2 (func1 a))
```

これはパイプライン演算子を使って次のようにも書ける

```elm
func1 a |> fucn2 |> func3
```

こちらでもOK↓

```elm
a |> func1 |> func2 |> func3
```

改行するとより見やすいケースもある↓

```elm
 a
 	|> func1
	|> func2 b c
	|> func3 (d + e)
```

パイプライン演算子を使うと、このように処理を順番につなげて書ける。他のプログラミング言語におけるメソッドチェーンによく似ている。
ただし、メソッドチェーンはオブジェクトが持つメソッドにしかつなげることができない。パイプライン演算子では処理を途切れさせることなく別の関数を次々につなげられる！！

#### パイプライン演算子は何をやっているのか？

パイプライン演算子は、（パイプライン演算子よりも）左側の部分の結果を、右側の部分へ最後の引数として渡している。

ここでもう一度以下のサンプルコードを追ってみる。

**Elm**

```elm
 a
 	|> func1
	|> func2 b c
	|> func3 (d + e)
```

- １つ目の`|>`は左側の`a`を右側の`func1`へ渡している。
- 2つ目の`|>`は左側の`a |> func1`の結果を右側の`func2 b c`へ渡している。この`func2 b c`は`func2`に`b`と`c`を部分適用したもので、最後の引数を`|>`から受け取っている。
- 3つ目の`|>`は左側の`a |> func１ |> func2 b c`の結果を右側の`func3 (d + e)`へ渡している。`func3 (d + e)`は`func3`に`d+e`を部分適用したもの、最後の引数を`|>`から受け取っている

パイプライン演算子では部分適用がされているのが分かっただろうか。関数がカリー化されていることで、部分適用ができ、それによってパイプライン演算子が扱えるといわけだ。

## まとめ

- 高階関数は関数を引数に取るor関数を返すような関数(両方満たす場合も高階関数)
- 複数引数の関数を1引数関数から成る関数に変換することをカリー化という
- カリー化された関数は高階関数でもある
- カリー化された関数は部分的用ができる
- 部分的用とは、関数に一部の引数のみを適用すること
- 部分的用によって関数の再利用がしやすくなったり、コードを綺麗にかけたりする
- Elmなどの言語でパイプライン演算子を使うとメソッドーチェーンのように次々に処理をつなげて書くことができ、処理の段階がわかりやすくなる
- パイプライン演算子は高階関数、カリー化、部分的用に支えられている
