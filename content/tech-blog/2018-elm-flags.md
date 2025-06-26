---
title: "[Elm] Flags: JavaScript から Elm を引数付きで初期化する"
# image: "/images/tech-blog/slug/image.jpg"
description: "ElmのFlagsを使ってJavaScriptからElmに引数を渡し、Elmアプリケーションを初期化する方法を紹介する。"
published: "2018-12-04"
updated: "2025-06-26"
category: "tech"
tags: ["elm"]
---

## Flags を Elm に渡して初期化する

JavaScript から Elm へ作用するような使い方として、 Flags を用いてElmのプログラムを初期化する方法がある。  
これは、外部の JavaScript から Elm へ初期化用のパラメーター(**\*1**) 渡し、それを用いて Elm のプログラム内で初期化処理を行うというものである。  
用途としては、例えば JavaScript で LocalStrage に保存されたデータを取得し、それを Elm の初期状態作成に用いることが挙げられる。

**P.S.** Flags だと LocalStrage からデータを取得して Elm を初期化するというのはできるけれど、LocalStrage へ保存することは出来ないので、あまり実用的な例とは言えなさそう。ちなみに、Flags でなく Ports を使えば、Elm から JS を介して LocalStrage への読み書きができる。  
別の用途を挙げるなら、開発用と本番用で Elm プログラムの挙動や表示を変えたいときに、それを表す値を Flags で渡して初期化する、というケースも考えられるだろう。他には、Elm 側で環境変数を参照したいときなんかに、JS で環境変数を取得しておいて Flags で渡すとか。

**\*1** コマンドラインのフラグに見られるような感じで追加パラメーターを渡すので、Elmではこれを`Flags`と呼ぶ。

Flags を使うためには、大まかに次のことが必要になる。

1. Flags を受け取れる init 関数を持つような、Elm のプログラムを用意する
2. Elm をコンパイルして JavaScript を生成する
3. 外部の JavaScript プログラムから Elm の初期化処理を行う

ここから先では  
「JavaScript から Elm へ数値を渡し、Elm がその数値の回数分だけ`Hello World!`と表示すること」  
を目標として、そのためには上記1〜3をどうすればよいのか を追っていく。

(例えば `4`を渡すと以下の表示がされるようにする)

```
Hello World!
Hello World!
Hello World!
Hello World!
```

### 1. Flags を受け取れる init 関数を持つような、Elm のプログラムを用意する

まず、Elm の`main`関数にどの`Browser.xxx`を使えばよいかを考えてみる。

Elm 0.19 には４種類の`xxx`があり、[https://package.elm-lang.org/packages/elm/browser/1.0.1/](https://package.elm-lang.org/packages/elm/browser/1.0.1/) によると次に引用する順番で次第に機能が拡張されたものとなっている。

> `sandbox` — react to user input, like buttons and checkboxes
> `element` — talk to the outside world, like HTTP and JS interop
> `document` — control the &lt;title&gt; and &lt;body&gt; > `application` — create single-page apps

今回は JavaScript が Elm に作用するような使い方がしたいので、`Browser.element`以降のいずれかを用いればよいとわかる。

`Browser.element`が今回の用途には必要最小限なので、これを用いることにする。

`main`関数は`Browser.element`を用いて次のようになる。

```elm
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
```

次に`init`関数を定義する。  
今回は、JavaScript から Elm へ渡される`Flag(s)`は`Int`型であるものとしよう。  
`init`関数は`Int`型の値を JavaScript から受け取るので、次のように定義する。

```elm
init : Int -> ( Model, Cmd msg )
init flag =
  ( { times = flags }, Cmd.none )

type alias Model =
  { times : Int }
```

あとは適当に `view`,`update`,`subscription`も用意してやれば、Elmプログラムは完成だ。  
ちなみに、`view`は`model.times`の回数分だけ`Hello World!`と表示するようなものになっている。`update`と`subscription`は何の変化ももたらさない関数とした。

**Main.elm**

```elm
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import List

main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

init : Int -> ( Model, Cmd msg )
init flags =
  ( { times = flags }, Cmd.none )

type alias Model =
  { times : Int }

type Msg
  = NoMessage

update : Msg -> Model -> ( Model, Cmd msg)
update msg model =
  ( model, Cmd.none)

view : Model -> Html Msg
view model =
  div [] <|
    List.repeat model.times <| div [] [ text "Hello World!" ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
```

### 2. Elm をコンパイルして JavaScript を生成する

1 で作成した Elm をただ単に`$ elm make Main.elm`としてコンパイルすると、`HTML`ファイルにコンパイルされてしまう。

今回のように JavaScript から Elm が作用を受けるためには、Elm を JavaScript へコンパイルする必要がある。そのためには、`--output`オプションで拡張子を`.js`となるように指定しよう。

```
$ elm make --output=main.js Main.elm
```

これで、`main.js`という JavaScriptのファイルへコンパイルされる。

`main.js`において、Elm のプログラム全体は`Elm.Main`というモジュールになっており、`init`関数は`Elm.Main.init`という関数として外部から利用できる。

### 3. 外部の JavaScript プログラムから Elm の初期化処理を行う

次の`index.html`では、埋め込みの JavaScript プログラムによって Elm を初期化している。

**index.html**

```html
<!doctype html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Main</title>
    <script src="main.js"></script>
  </head>

  <body>
    <div id="elm"></div>
    <script>
      var app = Elm.Main.init({
        node: document.getElementById("elm"),
        flags: 4,
      });
    </script>
  </body>
</html>
```

`<script src="main.js"></script>`と記述することで、Elm をコンパイルして生成した`main.js`をロードし`Elm.Main.init`関数を利用できるようにしている。

JavaScript 部分で`Elm.Main.init`関数を呼び出しているが、ここで  
Elm へ割り当てるノードを`node`キーで渡し、初期化に用いる Flags を`flags`キーで渡す。

これにより、Elm は`4`で初期化され、`<div id="elm"></div>`のノードとして表示される。

以上で完了だ。

## Flags に key-value pair (Dictionary) を用いる

これまでのコードでは、JavaScript から Elm に`flags: 4`を渡していた。  
(この`flags`を用いて Elm のプログラムは初期化され、結果として `Hello World!`が`4`回表示された。)

しかし 1つの値を渡しただけでは不十分で、複数の値を`Flags`で渡したくなることもあるだろう。

そこでここからは、表示する文字列も、表示する回数も、両方とも JavaScript から指定するように変更を加えていく。

`flags: {greeting: <表示させる文字列>, times: <回数>}`のようにして、key-value のペアとして渡すことにする。

例えば`flags: {greeting: "Hello Again, World!", times: 8}`とすれば以下のように表示されることが目標だ。

```
Hello Again, World!
Hello Again, World!
Hello Again, World!
Hello Again, World!
Hello Again, World!
Hello Again, World!
Hello Again, World!
Hello Again, World!
```

### JavaScript 側の変更

`index.html`に埋め込んだ JavaScript のコードを次のように変更する。
(変わったのは`flags`のみ)

```html
<script>
  var app = Elm.Main.init({
    node: document.getElementById("elm"),
    flags: { greeting: "Hello Again, World!", times: 8 },
  });
</script>
```

### Elm 側の変更

Main.Elm も合わせて変更していく。

まず`Flags`型を Dictionary として定義。  
JavaScript から渡される`flags`と Elm 側の`Flags`型で key を合わせている。

```
type alias Flags =
  { greeting : String
  , times : Int
  }
```

次に`init`関数が`Flags`型の値を引数にとるよう修正する。  
引数`flags`を用いて初期状態を作成している。  
それと、`Model`が`greeting`と`times`を両方持てるように変えておこう (view 関数に渡せるようにするため)。

```elm
init : Flags -> ( Model, Cmd msg )
init flags =
  ( { greeting = flags.greeting
    , times = flags.times
    }
  , Cmd.none
  )

type alias Model =
  { greeting : String
  , times : Int
  }
```

最後の変更は`view`関数。  
`greetings`を`times`の回数分、繰り返し表示する。

```elm
view : Model -> Html Msg
view model =
  div [] <|
    List.repeat model.times <| div [] [ text model.greeting ]
```

これで、JavaScript から JSON の Flags を Elm に渡せるようになり、それによって表示も変更出来た。

### 変更後のコード全体

**index.html**

```html
<!doctype html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Main</title>
    <script src="main.js"></script>
  </head>

  <body>
    <div id="elm"></div>
    <script>
      var app = Elm.Main.init({
        node: document.getElementById("elm"),
        flags: { greeting: "Hello Again, World!", times: 8 },
      });
    </script>
  </body>
</html>
```

**Main.elm**

```elm
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import List

main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- INIT

init : Flags -> ( Model, Cmd msg )
init flags =
  ( { greeting = flags.greeting
    , times = flags.times
    }
  , Cmd.none
  )

type alias Flags =
  { greeting : String
  , times : Int
  }

-----


type alias Model =
  { greeting : String
  , times : Int
  }

type Msg
  = NoMessage

update : Msg -> Model -> ( Model, Cmd msg)
update msg model =
  ( model, Cmd.none)

view : Model -> Html Msg
view model =
  div [] <|
    List.repeat model.times <| div [] [ text model.greeting ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
```

[GitHubはこちら](https://github.com/hahnah/til-elm/tree/master/flags)

## 参考サイト

- [https://guide.elm-lang.org/interop/](https://guide.elm-lang.org/interop/)
- [https://guide.elm-lang.org/interop/flags.html](https://guide.elm-lang.org/interop/flags.html)
- [https://package.elm-lang.org/packages/elm/browser/1.0.1/](https://package.elm-lang.org/packages/elm/browser/1.0.1/)
