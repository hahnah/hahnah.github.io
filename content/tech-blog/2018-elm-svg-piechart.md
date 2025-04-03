---
title: "[Elm] SVGで円グラフを表示する方法"
image: "/images/tech-blog/2018-elm-svg-piechart/piechart.avif"
description: "Elm で SVG を使って円グラフを表示する方法を紹介する。"
published: "2018-10-30"
updated: "2025-04-03"
category: "tech"
tags: ["elm", "svg", "chart"]
---

実装にあたり以下のページを参考にしている。  
[SVGで円グラフを描くシンプルな方法](https://ksk-soft.com/2014/08/06/svg-pie-graph/)

## 実装環境

Elm 0.19

## 実装

以下のように import を記載している前提で、実装を紹介していく。

```elm
import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import List
import Maybe
import Svg exposing (svg, circle)
import Svg.Attributes exposing (viewBox, width, cx, cy, r, fill, fillOpacity, stroke, strokeWidth, strokeDashoffset, strokeDasharray)
```

また、次に定義する型を用いて実装している。

```elm
type alias Item =
  { count: Int }

type alias Color =
  String

type alias FanShape =
  { offset: Float
  , percentage: Float
  , color: Color
  }
```

上記の`Item.count`にはデータの値が入る。  
例えば年代ごとの人口比率を円グラフにしたいなら、ある年代の人口が Item.count の値になる。  
(パーセンテージではない)

`FanShape`型については後ほど説明する。

### 1. 扇形を描く

参考サイトの方法を Elm で実装し、扇形を描く関数`viewFanShape`をつくる

```elm
viewFanShape : FanShape -> Html Msg
viewFanShape fanShape =
  let
    strokeDashoffset_ = String.fromFloat <| 25.0 - fanShape.offset
    strokeDasharray_ = String.fromFloat fanShape.percentage ++ " " ++ (String.fromFloat <| 100.0 - fanShape.percentage)
  in
    circle
      [ cx "31.8309886184", cy "31.8309886184", r "15.9154943092"
      , fill "#ffffff", fillOpacity "0.0"
      , stroke fanShape.color, strokeWidth "31.8309886184", strokeDashoffset strokeDashoffset_, strokeDasharray strokeDasharray_ ]
      []
```

ここで`viewFanShap`関数は、扇形を表す`FanShape`型の値を引数に取るが、`FanShape`が持つ値には次の意味を持たせている。

- `offset`: 扇形をどれだけ回転させて描画するかを指す値。回転の度合いは0〜１００[%]で表す。
- `percentage`: 扇形の弧の長さが円周に占める割合を0〜100[%]で示しており、すなわち円グラフ上でのパーセンテージを表す。
- `color`: 扇形の色を16進数のカラーコードで表す。

```elm
-- 再掲
type alias FanShape =
  { offset: Float
  , percentage: Float
  , color: Color
  }
```

### 2. 複数の扇形を組み合わせて円グラフを描く

値`fanShapes : List FanShape`を用意し、これと`viewFanShape`関数を`List.map`関数にかけることで扇形の DOM Element のリストを生成することができる。

それを Svg.svg ノードの引数にとることで円グラフが描画できる。

```elm
svg
  [ viewBox "0 0 63.6619772368 63.6619772368" , width "300px" ]
  (List.map viewFanShape fanShapes)
```

次の実装では、`fanShapes: List FanShape`を作成するために、以下のものを準備している。

- `percentages`: 個々のデータが全体に占めるパーセンテージを表すリスト。
- `offsets`: 扇形のオフセット[%]のリスト。N個目のオフセットは、N-1個目までのパーセンテージの合計。
- `colors`: 扇形の色のリスト。(実装では直接引数にしている)

```elm
viewPieChart : List Item -> List Color -> Html Msg
viewPieChart items colors =
  let
    counts = List.map (\item -> toFloat item.count) items
    total = List.sum counts
    percentages = List.map (\count -> 100.0 * count / total) counts
    offsets = List.foldl (\percentage acc -> List.append acc [(Maybe.withDefault 0.0 <| List.maximum acc) + percentage]) [0.0] percentages
    fanShapes = List.map3 (\offset percentage color -> FanShape offset percentage color) offsets percentages colors
  in
    svg
      [ viewBox "0 0 63.6619772368 63.6619772368" , width "300px" ]
      (List.map viewFanShape fanShapes)
```

これで、円グラフを描画する`viewPieChart`関数ができた。

## サンプルコード全体

[GitHub](https://github.com/hahnah/til-elm/tree/master/pie-chart)にもあり。

```elm
import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import List
import Maybe
import Svg exposing (svg, circle)
import Svg.Attributes exposing (viewBox, width, cx, cy, r, fill, fillOpacity, stroke, strokeWidth, strokeDashoffset, strokeDasharray)


-- MODEL

type alias Model =
  { items: List Item
  , colors: List Color
  }

init : Model
init =
  let
    items =
      [ Item 34
      , Item 21
      , Item 13
      , Item 8
      , Item 5
      , Item 3
      , Item 2
      , Item 1
      , Item 1
      ]
    colors =
      [ "#ff7f7f"
      , "#bf7fff"
      , "#bfff7f"
      , "#7fffff"
      , "#ff7fbf"
      , "#7f7fff"
      , "#ffff7f"
      , "#ff7fff"
      , "#ffbf7f"
      ]
  in
    Model items colors

type alias Item =
  { count: Int }

type alias Color =
  String

type alias FanShape =
  { offset: Float
  , percentage: Float
  , color: Color
  }


-- MSG

type Msg = NoMsg


-- UPDATE

update : Msg -> Model -> Model
update message model = model

-- VIEW

view : Model -> Html Msg
view model =
  div [] [ viewPieChart model.items model.colors ]

viewPieChart : List Item -> List Color -> Html Msg
viewPieChart items colors =
  let
    counts = List.map (\item -> toFloat item.count) items
    total = List.sum counts
    percentages = List.map (\count -> 100.0 * count / total) counts
    offsets = List.foldl (\percentage acc -> List.append acc [(Maybe.withDefault 0.0 <| List.maximum acc) + percentage]) [0.0] percentages
    fanShapes = List.map3 (\offset percentage color -> FanShape offset percentage color) offsets percentages colors
  in
    svg
      [ viewBox "0 0 63.6619772368 63.6619772368" , width "300px" ]
      (List.map viewFanShape fanShapes)

viewFanShape : FanShape -> Html Msg
viewFanShape fanShape =
  let
    strokeDashoffset_ = String.fromFloat <| 25.0 - fanShape.offset
    strokeDasharray_ = String.fromFloat fanShape.percentage ++ " " ++ (String.fromFloat <| 100.0 - fanShape.percentage)
  in
    circle
      [ cx "31.8309886184", cy "31.8309886184", r "15.9154943092"
      , fill "#ffffff", fillOpacity "0.0"
      , stroke fanShape.color, strokeWidth "31.8309886184", strokeDashoffset strokeDashoffset_, strokeDasharray strokeDasharray_ ]
      []

 -- MAIN

main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }
```

## 参考

[SVGで円グラフを描くシンプルな方法](https://ksk-soft.com/2014/08/06/svg-pie-graph/)
