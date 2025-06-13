---
title: "Reduxでのディレクトリ構成3パターンに見る「分割」と「分散」"
image: "/images/tech-blog/2019-redux-directory-petterns/baby-duck.avif"
description: "Reduxを使う場合に限らず、ディレクトリ構成を考える際には「分割」と「分散」の度合いを意識することが役に立つ。これについて例を示しながら解説する。"
published: "2019-09-26"
updated: "2025-06-13"
category: "tech"
tags: ["frontend", "react", "redux", "directory-structure"]
---

Redux を使っていいて、ディレクトリ構成に悩んだことはないだろうか。  
もしくは、見かけるディレクトリ構成が多様で、どれがいいのか分からないなんてことはなかっただろうか。

この記事では Redux を用いる際の代表的な３パターンの構成を紹介するとともに、それぞれをソースコードの分割・分散の度合いで比べてみる。

1. redux-way
2. ducks
3. re-ducks

## パターン1. redux-way (あるいは Rails-style)

redux-way では、 "Redux によって導入される概念" ごとにディレクトリを分ける。  
以下のように`components/`,`containers/`,`reducers/`,`actions/`,`types/`などとディレクトリを設けるケースが多いようだ。  
それぞれのディレクトリでは、対応する component 毎にさらにファイルを分ける (以下の例ではcomponent1.js, component2.js, ...)。

```
src/
  ├ components/
  │    ├ component1.js
  │    └ component2.js
  ├ containers/
  │    ├ component1.js
  │    └ component2.js
  ├ reducers/
  │    ├ component1.js
  │    └ component2.js
  ├ actions/
  │    ├ component1.js
  │    └ component2.js
  └ types/
       ├ component1.js
       └ component2.js
```

[Redux公式のFAQ](https://redux.js.org/faq/code-structure) には **Rails-style** というものが紹介されているが、これとほぼ同じ。

> Rails-style: separate folders for “actions”, “constants”, “reducers”, “containers”, and “components”

### redux-way の問題点

redux-way は至って普通のディレクトリ構成ではあるが、閲覧性が悪く関連性を理解しづらいという問題があり、これは **過剰な分割** と **過剰な分散** に起因している。

reducers, action creators, action types の3つは密結合になっているにも関わらず、それぞれが異なるファイルに **分割** されており、さらには異なるディレクトリに **分散** している。そのため関連性を把握しづらくなってしまう。

例えば、`reducers/component1.js` に定義する reducer は 受け取った action を計算に用いるのだが、どのような action を受け取り得るのかは action creator を定義する `actions/component1.js` を見なければ分からず、また action creator が返す action の構成要素である action type が取りうる値は `types/component1.js` を見なければ分からないようになっている。

## パターン2. ducks

先に挙げた redux-way の **過剰な分割** と **過剰な分散** を解消するようなディレクトリ構成に、 **ducks** と呼ばれるものがある。

**参考：**

- [The Ducks File Structure for Redux](https://medium.com/@scbarrus/the-ducks-file-structure-for-redux-d63c41b7035c)
- [erikras/ducks-modular-redux -- GitHub](https://github.com/erikras/ducks-modular-redux)

redux-way において reducers, action creators, actions types の関数・定数定義は`reducers/`, `actions/`, `types/`のディレクトリに分散していたが、 ducks ではこれら3つを単に1つの**`modules/`** ディレクトリとしてまとめ、 **過剰な分散** が解消される。

このとき`modules/`配下において `component1`に関する reducers, action creators, action types の定義は別々のファイルに分割することもできるが、ducks においては **過剰な分割** の解消のため、単一のファイルにまとめる(`modules/component1.js`)。

```
src/
  ├ components/
  │    ├ component1.js
  │    └ component2.js
  ├ containers/
  │    ├ component1.js
  │    └ component2.js
  └ modules/
       ├ component1.js
       └ component2.js
```

ducks のディレクトリ構成では密結合な reducers, action creators, action types の定義が１ファイルで記述され、非常に簡潔で見通しが良くなる。

### ducks の課題と対策

特に小規模なプロダクトにおいては ducks のシンプルな構成がマッチすると思われるが、中・大規模になってくると１ファイルがどうしても大きくなり、ファイル内での閲覧性が悪くなってしまう。

そうした場合には以下のようなファイル分割を行うのが良さそうだ。  
ファイルを分割したものの 3つとも同一ディレクトリにあり、 分散はしていない。

```
modules/
  ├ component1/
  │    ├ reducer.js
  │    ├ actions.js
  │    └ types.js
  └ component2/
       ├ reducer.js
       ├ actions.js
       └ types.js
```

これと似たディレクトリ構成として **re-ducks** と呼ばれるものがあるので、次章で紹介する。
上記のように分割したくなるケースでは、re-ducks の構成にするのがより一般的だろう。

## パターン3. re-ducks

先にも述べたように、中・大規模のプロダクトになってくるとファイル１つが大きくなり、ducks の構成が辛くなってくる。  
その解消のために **re-ducks** という構成が考え出された。

**参考:**

- [Scaling your Redux App with ducks](https://www.freecodecamp.org/news/scaling-your-redux-app-with-ducks-6115955638be/)
- [alexnm/re-ducks -- GitHub](https://github.com/alexnm/re-ducks)

re-ducks では次のようなディレクトリ構成となり、ducksにおける `modules/` は `duck/` で置き換わる。

```
src/
  ├ components/
  │    ├ component1.js
  │    └ component2.js
  ├ containers/
  │    ├ component1.js
  │    └ component2.js
  └ duck/
       ├ component1/
       │    ├ index.js
       │    ├ recucers.js
       │    ├ actions.js
       │    ├ types.js
       │    ├ operations.js
       │    └ selectors.js
       └ component2/
            ├ index.js
            ├ recucers.js
            ├ actions.js
            ├ types.js
            ├ operations.js
            └ selectors.js
```

`duck/` の下では component 毎にディレクトリが分かれ、それぞれに`reducer.js`, `actions.js`, `types.js`を置く。これにより、ducks の構成で問題となり得る 長大な単一ファイル を分割することで解消しつつも、密結合なファイルたちが同一ディレクトリに集まっているので 分散 はしていない。

re-ducks では新しく`operations.js`と`selectors.js`が登場するが、ここまでの話とは異なる動機で追加されるものなので、説明は省く (というか、そもそも私が詳しく知らないので上手く説明できない)。

ちなみに`index.js`はそれぞれのファイルに散らばった定義を import して export し直すだけのファイル。  
外から使う際には`index.js`から必要な全てを import できるようになる。

## まとめ

- Redux を用いたプロダクトのディレクトリ構成には、代表的なものとして redux-way, ducks, re-ducks の3つがある。
- redux-way では、 reducers, action creators, action types について 過剰な分割 と 過剰な分散が起こり得る。
- ducks では分割も分散もなく、非常に簡潔にまとまる。小規模プロダクトに向く。
- re-ducks では 分割はするが分散はしない。中・大規模プロダクトに向く。

ducks の構成でプロダクトを始め、成長にあわせて re-ducks に切り替えるのが良さそうだ。

また、Redux を使う場合に限らず、 ディレクトリ構成を考える際には **分割** と **分散** の度合いを意識することでより良い構成へ近づけるだろう。
