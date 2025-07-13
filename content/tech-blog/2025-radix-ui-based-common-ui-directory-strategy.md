---
title: "Radix UI ベースで作った共有UIディレクトリ構成をどうするか？"
# image: "/images/tech-blog/slug/image.jpg"
description: "Radix UI を使って共通UIコンポーネントを作る際の、そのディレクトリの構成について考える。"
published: "2025-07-13"
# updated: "2025-02-20"
category: "tech"
tags: ["react", "radix-ui"]
---

## Radix UI の特徴

[Radix UI](https://www.radix-ui.com/) はヘッドレスUIコンポーネントライブラリだ。「レイディックス・ユーアイ」と読む。
Radix UI は1つのUIを提供するために複数のパーツUIを提供している、一風変わったスタイルだ。

しかしこれは非常に示唆に富んでいて、あらゆる見た目・昨日のUIを1つのUIコンポーネントライブラリで実現できるほどに汎用性を持たせるためには、Radix UI のようにパーツ化してUIコンポーネントを提供するのが理にかなっている。  
そうでなければ、大量のpropsを持つ巨大のUIコンポーネントが誕生してしまい、カスタマイズの仕方すらわからないだろう。
また、ちょっと凝ったUI構造を表現しようとするケースを考えると、やはりパーツとなるUIを提供して実装者にUI構造を組み立ててもらった方が確実なのだ。

例えば、Radix UI の `Dialog` は以下の6つのパーツを提供している。

- Root
- Trigger
- Content
- Title
- Description
- Close

それらを組みあせてモーダルダイアログを実装している例が以下だ。  
(コードは[https://www.radix-ui.com/themes/docs/components/dialog](https://www.radix-ui.com/themes/docs/components/dialog)より)

※本題からそれるのでサンプルコードを理解する必要はない

```tsx
<Dialog.Root>
  <Dialog.Trigger>
    <Button>Edit profile</Button>
  </Dialog.Trigger>
  <Dialog.Content maxWidth="450px">
    <Dialog.Title>Edit profile</Dialog.Title>
    <Dialog.Description size="2" mb="4">
      Make changes to your profile.
    </Dialog.Description>

    <Flex direction="column" gap="3">
      <label>
        <Text as="div" size="2" mb="1" weight="bold">
          Name
        </Text>
        <TextField.Root
          defaultValue="Freja Johnsen"
          placeholder="Enter your full name"
        />
      </label>
      <label>
        <Text as="div" size="2" mb="1" weight="bold">
          Email
        </Text>
        <TextField.Root
          defaultValue="freja@example.com"
          placeholder="Enter your email"
        />
      </label>
    </Flex>

    <Flex gap="3" mt="4" justify="end">
      <Dialog.Close>
        <Button variant="soft" color="gray">
          Cancel
        </Button>
      </Dialog.Close>
      <Dialog.Close>
        <Button>Save</Button>
      </Dialog.Close>
    </Flex>
  </Dialog.Content>
</Dialog.Root>
```

## Radix UI をベースに共通UIコンポーネントを作るとどうなるか

ある程度固まり切ったパターンしかないUIならは、1コンポーネントだけを提供する(普通の形式の)共通UIとして作れるだろう。

しかし、様々なパターンが存在するUIや柔軟性が求めらる場合、1コンポーネントとして表現しきれないことは多い。  
そいった場合、Radix UI と同様に、パーツを提供する形で共通UIコンポーネントを作るのが理にかなっている。

Dialog で言えば、Title コンポーネントに決まったスタイルを当ててラップしたり、Content の大きさや背景色・枠線の色太さ・角の丸まりなどが決まっているなら、それらのスタイルを当てたコンポーネントを提供することができる。  
Content の大きさがものによって違うのであれば、それを引数で受け取るように設計するか、もしくは使う側でスタイルを当てさせるように設計することもできる。

そう考えた時に、次のUI提供方法に落ち着く。

## 共通UIディレクトリ構成

決まり切っているUIコンポーネントは、Radix UI を使って単一のUIコンポーネントとして作り上げる(可能であれば)。  
これを **composed/** ディレクトリに置くことにする。

一方で、1つのコンポーネントに納め切ることができないような、Radix UI のようにパーツを提供する場合は、**primitives/** ディレクトリに置くことにする。  
これは、Radix UI をラップしたものになる。

````
src/
  ┗ ui/
    ┣ composed/   // (基本的に)一つのUIコンポーネントを提供するだけで事足りるものはここ
    ┃ ┗ Toast.tsx
    ┗ primitives/ // Radix UI のように、UIを構成するパーツを提供するものはここ
        ┗ Dialog.tsx
    ```
````

composed/ のものは簡単に使えるというメリットがあるので、可能なら composed になるよう仕上げられないか、努力をしたいところだ。  
primitive/ のものは、Radix UI のようにパーツを組み合わせて使うことが前提となるので、慣れるまでは使い方が少し難しい。その分、どんなUIデザインにも柔軟に対応できるだろう。

## 終わり

Radix UI はいいぞ！
