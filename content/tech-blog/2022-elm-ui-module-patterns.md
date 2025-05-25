---
title: "ElmにおけるUIモジュールの構成パターン"
# image: "/images/tech-blog/slug/image.jpg"
description: "私が Elm を書く際に UI をどのようにモジュール化しているか、そのパターンを書いてみる。"
published: "2022-01-26"
updated: "2025-05-25"
category: "tech"
tags: ["elm", "ui", "nested-tea"]
---

(サンプルコードは Elm 0.19)

## 汎用的なUIや類似のUI群の場合

前提として、基本的にはUIは単なるビューの関数として利用モジュール内にそのまま定義するだけで十分である。
それを踏まえた上で、以下のいずれかに当てはまる場合にはUIのビュー関数を別モジュールに切り出すようにしている:

- 再利用性の高いUIである 類似性のあるビュー関数(例えばボタンUIのパターン違いなど)をひとまとまりにすることで見通しをよくしたい

例えば以下のような `MyUi` モジュールとして実装する。

**MyUi.elm**

```elm
module MyUi exposing(myUi, myUiWithOptions)

import Html exposing (Html)

type alias Props =
	{ ... } -- (記述省略)

myUi : Props -> Html msg
myUi props =
	... -- (記述省略)

type alias Options =
	{ ... } -- (記述省略)

myUiWithOptions : Props -> Options -> Html msg
myUiWithOptions props options =
	... -- (記述省略)
```

## 専用的なUIや複雑なUIの場合

以下のいずれかに当てはまるときには Nested TEA (後述) の設計パターンでUIモジュールを作るようにしている:

- 特殊な仕様を盛り込んだ専用的なUIであり、汎用性を持たせて再利用できるようなモジュールとして作ることが難しい
- そのUIについての状態管理が複雑あるいはコードの分量があまりにも多く、もしそのUIの利用側(典型的にはMainモジュール)でその状態管理の詳細を定義しようとするとコードの見通しが悪くなる

以下のサンプルコードに示す `MyUi` モジュールのように実装する

- MyUi に関連する状態を MyUi モジュール内に定義 (`Model`)
- MyUi に関連するメッセージを MyUi モジュール内に定義 (`Msg`)
- MyUi に関連する状態更新を MyUi モジュール内に定義 (`update`)
- MyUi のビューを MyUi モジュール内に定義 (`view`)

**MyUi.elm**

```elm
module MyUi exposing (Model, Msg, update, view)

import Html exposing (Html)
import Html.Events


type alias Model =
    { hoge : Bool
    , fuga : Int
    , piyo : String
    }


type Msg
    = Msg1
    | Msg2
    | Msg3
    | Msg4


update : Msg -> Model -> Model
update msg model =
    case msg of
        Msg1 ->
            aNewModel -- (記述省略。以下も同様。)

        Msg2 ->
            anotherNewModel

        Msg3 ->
            yetAnotherNewModel

        Msg4 ->
            yetYetAnotherNewModel


view : Model -> Html Msg
view model =
    Html.div
        [ Html.Events.onClick <|
            if model.hoge then
                Msg1

            else
                Msg2
        , Html.Events.onMouseEnter Msg3
        , Html.Events.onMouseLeave Msg4
        ]
        [ Html.text "Hello!" ]

```

そして `MyUi` の利用側(ここでは `Main`) は次のように書ける。

**Main.elm**

```elm
module Main exposing (main)

import Browser
import Html exposing (Html)
import Html.Events
import MyUi


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { count : Int
    , myUi : MyUi.Model
    }


init : Model
init =
    { count = 0
    , myUi = { hoge = False, fuga = 0, piyo = "" }
    }


type Msg
    = Increment
    | MyUi MyUi.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        MyUi myUiMsg ->
            { model | myUi = MyUi.update myUiMsg model.myUi }


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.button [ Html.Events.onClick Increment ] [ Html.text <| String.fromInt model.count ]
        , MyUi.view model.myUi |> Html.map MyUi
        ]
```

Main モジュールにおける `Model`, `Msg`, `update`, `view` は、`MyUi.Model`, `MyUi.Msg`, `MyUi.update`, `MyUi.view` をそれぞれ利用しており、MyUi に関わる詳細は Main モジュール内では一切触れていない。詳細は全て MyUi モジュールに隠蔽されており、外からは詳細を意識しなくていいようになっている。

そして、Main モジュールが　TEA (The Elm Architecture) の設計になっているのはもちろんのこと、そのパターンが MyUi モジュールにも現れている。親子に入れ子となって TEA　が現れるこのような設計パターンは `Nested TEA` と呼ばれる。

1つコードの補足をしておくと、`view` 関数で `MyUi.view model.myUi |> Html.map MyUi` としているように `Html.map` を用いることで、 `MyUi.view` から発行される `MyUi.Msg` が (Mainモジュールにおける) `MyUi` でラップされて `MyUi MyUi.Msg` となる。(ちなみにラップするバリアントは何でもよく、`Foo` でラップすれば `Foo MyUI.Msg` となる)
