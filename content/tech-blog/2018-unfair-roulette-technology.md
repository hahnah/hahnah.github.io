---
title: "Elmで開発したルーレットアプリの実装解説"
image: "/images/tech-blog/2018-unfair-roulette-technology/with-pc.avif"
description: "Unfair Roulette は止まる目を操作することができる、そんなルーレットだ。それをElmがどのように実装したのかを解説する。"
published: "2018-12-01"
updated: "2025-04-06"
category: "tech"
tags: ["unfair-roulette", "hahnah's-app", "elm"]
---

以下の記事で説明しているルーレットアプリをElmで作成した。  
[Unfair Roulette : インチキできるルーレットアプリを作成した](https://hahnah.github.io/tech-blog/2018-unfair-roulette/)

どのような実装になっているかをソースコードや図表とともに解説する。

## 1. アプリについて

- アプリ名 : [Unfair Roulette](https://hahnah.github.io/unfair-roulette/) &#x1f448;このリンクからアプリを試せる
- アプリ概要 : [Unfair Roulette : インチキできるルーレットアプリを作成した](https://hahnah.github.io/tech-blog/2018-unfair-roulette/)
- 開発言語 : Elm 0.19
- ソースコード : [https://github.com/hahnah/unfair-roulette/tree/1.0.0](https://github.com/hahnah/unfair-roulette/tree/1.0.0)

## 2. 状態遷移の仕様

このアプリは複数の状態(シーン)からなり、状態受け取ったメッセージの組み合わせに応じて処理がなされる。

#### 状態遷移図

次の状態遷移図では、各状態において、メッセージ(青矢印)が出された場合にどの状態に遷移するかを示している。  
メッセージに応じて状態が変化したり、状態はそのままでもViewが更新されたりする。  
初期状態は図中左端の`EditingRoulette`である。

![state-transtion-diagram](/images/tech-blog/2018-unfair-roulette-technology/state-transition-diagram.avif)

それぞれの状態とメッセージの意味は次の通り。

#### 状態

| 状態                        | 説明                                                     |
| --------------------------- | -------------------------------------------------------- |
| EditingRoulette             | ルーレット（を構成するアイテム）を編集している状態       |
| RouletteSpinning            | ルーレットが回転している状態                             |
| RouletteSpinningTowardsStop | ルーレットが停止のタイミングを図りながら回転している状態 |
| RouletteStopped             | ルーレットが停止した状態                                 |
| ResultShowed                | ルーレットの結果が表示された状態                         |

#### メッセージ

| メッセージ                   | メッセージを受け取った際の処理                                                                                                                                                                                                       |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Increment                    | 指定されたアイテムの設定値を1増やす                                                                                                                                                                                                  |
| Decrement                    | 指定されたアイテムの設定値を1減らす                                                                                                                                                                                                  |
| ChangeLabel                  | 指定されたアイテムのラベルを、入力欄の文字列に変更する                                                                                                                                                                               |
| ChangeCount                  | 指定されたアイテムの設定値を、入力欄の数値に変更する                                                                                                                                                                                 |
| Clear                        | 指定されたアイテムの設定値とラベルをクリアする                                                                                                                                                                                       |
| Cheat                        | 指定されたアイテムでルーレットが停止するように設定する                                                                                                                                                                               |
| OnClickStart                 | ルーレット回転開始の条件を満たしていれば StartSpinningRoulette メッセージを出す                                                                                                                                                      |
| StartSpinningRoulette        | ルーレットの回転を開始する                                                                                                                                                                                                           |
| SpinRoulette                 | ルーレットの回転を進める。<br>ルーレットが停止条件を満たしていれば StopRoulette メッセージを出す。<br>(`SpinRoulette`メッセージは、Subscription により`RouletteSpinning`or`RouletteSpinningTowardsStop`状態の場合に定期的に出される) |
| AdjustDecayRateForSmoothStop | ルーレットの回転角速度の減衰率を調整する                                                                                                                                                                                             |
| StopRoulette                 | ルーレットの回転を停止する                                                                                                                                                                                                           |
| ShowResult                   | ルーレットの結果をダイアログで表示する                                                                                                                                                                                               |
| HideResult                   | ルーレットの結果ダイアログを閉じる                                                                                                                                                                                                   |

NOTE: 厳密には、例えば`Increment`は`Increment Counter`という型をしているが省略して表記している。他のメッセージも同様。

## 3. 各処理の実装詳細

一部の処理についてどう実装したかを紹介する。  
前提として、各処理では以下に定義する型が登場する。

```elm
-- MODEL

type alias Model =
  { scene: Scene
  , counters: Counters
  , maxCounters: Int
  , rotation: Float -- in percentage
  , rotationVelocity: Float
  , decayRate: Float
  , goalRotation: Float
  , pointedCounter: Counter
  , cheatedGoalRange: Maybe Range
  }

type alias Counters = List Counter

type alias Counter =
  { id: Int
  , label: String
  , count: Int
  }

type alias FanShape =
  { offset: Float
  , percentage: Float
  , color: String
  }

type alias Color = String

type alias Colors = List Color

type Scene
  = EditingRoulette
  | RouletteSpinning
  | RouletteSpinningTowardsStop
  | RouletteStopped
  | ResultShowed

type alias Range =
  { min: Float
  , max: Float
  }

type alias RotationRange =
 { min: Float
 , max: Float
 }
```

これより先を読む上で把握しておいてほしいのは`Counter`型と`FanShape`型だ。

- `Counter`はルーレットを構成する選択肢の呼び名と数値(例えば票数)を表す。ユーザーの操作で編集される。
- `FanShape`は、ルーレットを構成する扇形(の描画に必要な情報)を表す。`Counter`を用いて算出される。

これまで、この記事中でルーレットの`アイテム`と呼んでいたものは`Counter`であり`FanShape`である。

### 3.1 ルーレットの編集処理

![editing-roulette](/images/tech-blog/2018-unfair-roulette-technology/editing-roulette.avif)

#### Increment : 指定されたアイテムの設定値を1増やす

`model`には`Counters`型の値を持たせており、指定されたアイテム(`counter`)だけを1増やした`Counters`値を計算し、新しい`Model`を返す。

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case (msg, model.scene) of
    (Increment counter, EditingRoulette) ->
      let
        (front, back) = separateIntoFrontAndBack model.counters counter
        updatedCounter = { counter | count = counter.count + 1}
        updatedCounters = front ++ [updatedCounter] ++ back
      in
        ({ model | counters = updatedCounters }, Cmd.none)
```

ここで`separateIntoFrontAndBack`は、更新後の`Counters`値を計算するためのヘルパー関数である。

#### Decrement : 指定されたアイテムの設定値を1減らす

指定されたアイテム(`counter`)だけを1減らした`Counters`値を計算する。0以下にはならない。

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case (msg, model.scene) of
-- (中略)
    (Decrement counter, EditingRoulette) ->
      if 0 < counter.count then
        let
          (front, back) = separateIntoFrontAndBack model.counters counter
          updatedCounter = { counter | count = counter.count - 1}
          updatedCounters = front ++ [updatedCounter] ++ back
        in
          ({ model | counters = updatedCounters }, Cmd.none)
      else
        (model, Cmd.none)
```

#### ChangeCount : 指定されたアイテムの設定値を、入力欄の数値に変更する

`Increment`, `Decrement`1ずつしか増減されないが、`ChangeCount`では直接指定した数値に設定できる。数値入力欄への入力がされる度に`ChangeCount`がされる。

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case (msg, model.scene) of
-- (中略)
    (ChangeCount counter newCount, EditingRoulette) ->
      let
        (front, back) = separateIntoFrontAndBack model.counters counter
        updatedCounter = { counter | count = String.toInt newCount |> Maybe.withDefault (if newCount == "" then 0 else counter.count) }
        updatedCounters = front ++ [updatedCounter] ++ back
      in
        ({ model | counters = updatedCounters }, Cmd.none)
```

(書いていて今更気付いたが、`Increment`と`Decrement`なんてメッセージは不要で、`ChangeCount`だけで全て担える。DRYしよう。)

#### ChangeLabel : 指定されたアイテムのラベルを、入力欄の文字列に変更する

`ChangeCount`とほぼ同じ。指定されたアイテム(`counter`)のラベルを、入力文字列`newLabel`で置き換えた新しい`Model`値を返す。

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case (msg, model.scene) of
-- (中略)
    (ChangeLabel counter newLabel, EditingRoulette) ->
      let
        (front, back) = separateIntoFrontAndBack model.counters counter
        updatedCounter = { counter | label = newLabel}
        updatedCounters = front ++ [updatedCounter] ++ back
      in
        ({ model | counters = updatedCounters }, Cmd.none)
```

#### Clear : 指定されたアイテムの設定値とラベルをクリアする

指定されたアイテムの、ラベルと設定値を`""`(空文字)と`0`にした`Model`値を返す。

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case (msg, model.scene) of
-- (中略)
    (Clear counter, EditingRoulette) ->
      let
        (front, back) = separateIntoFrontAndBack model.counters counter
        updatedCounter = { counter | count = 0, label = "" }
        updatedCounters = front ++ [updatedCounter] ++ back
      in
        ({ model | counters = updatedCounters }, Cmd.none)
```

### 3.2 ルーレットの描画処理

ルーレットの描画（というより、扇形の描画）には、[\[Elm\] SVGで円グラフを表示する方法](https://hahnah.github.io/tech-blog/2018-elm-svg-piechart/)の記事の方法を用いた。細部は異なるが、基本的なやり方は同じ。

```elm
viewRoulette : Counters -> Colors -> Float -> Html Msg
viewRoulette counters colors rotation =
  let
    counts = List.map (\counter -> toFloat counter.count) counters
    total = List.sum counts
    percentages = List.map (\count -> 100.0 * count / total) counts
    offsets =
      List.foldl (\percentage acc -> List.append acc [(Maybe.withDefault 0.0 <| List.maximum acc) + percentage]) [0.0] percentages
        |> List.map ((+) rotation)
    fanShapes = List.map3 (\offset percentage color -> FanShape offset percentage color) offsets percentages colors
  in
    svg
      [ viewBox "0 0 63.6619772368 63.6619772368", width "500px", style "transform" "rotate(90deg)" ]
      (List.append (List.map (\fanShape -> viewFanShape fanShape) fanShapes) [viewRoulettePointer])

viewFanShape : FanShape -> Html Msg
viewFanShape fanShape =
  let
    strokeDashoffset_ = String.fromFloat <|  -fanShape.offset -- Fan shape direction is opposite to Svg.circle, becouse of the specification of dassArray. So I negat fanshape.offset.
    strokeDasharray_ = String.fromFloat fanShape.percentage ++ " " ++ (String.fromFloat <| 100.0 - fanShape.percentage)
  in
    circle
      [ cx "31.8309886184", cy "31.8309886184", r "15.9154943092"
      , fill "#ffffff", fillOpacity "0.0"
      , stroke fanShape.color, strokeWidth "31.8309886184", strokeDashoffset strokeDashoffset_, strokeDasharray strokeDasharray_ ]
      []

viewRoulettePointer : Html Msg
viewRoulettePointer =
  polygon
    [ points "63.6619772368,29.5309886184 63.6619772368,34.3309886184 57.6619772368,31.8309886184"
    , style "fill" roulettePointerColor
    ]
    []
```

`viewRoulette`関数では、まず引数で渡された`counters`や`rotation`(ルーレットの回転角\[%\]) をもとにして描画する扇形の情報`fanShapes`を算出する。  
それを、扇形を描画する`viewFanShape`関数に適用することで全ての扇形を描画する(つまりルーレットが描画される)。  
また、ルーレットの針を`viewRoulettePointer`関数で描画する。

### 3.3 ルーレットの針が指すアイテムを特定する処理

以下の`pointedCounter_`に、針が指すアイテム(`Counter`値)を計算しバインドしている。  
途中で用いる`calculateCollisionRanges`と`willBeNewlyPointed`の関数についても続けて説明する。

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case (msg, model.scene) of
-- (中略)
    (SpinRoulette _, RouletteSpinning) ->
      let
        pointedCounter_ =
          calculateCollisionRanges model.counters model.rotation
            |> List.map2 (\counter collisionRange -> Tuple.pair counter <| willBeNewlyPointed model.rotationVelocity collisionRange) model.counters
            |> List.filter (\(counter, willBeNewlyPointed_) -> willBeNewlyPointed_)
            |> List.head
            |> Maybe.withDefault (model.pointedCounter, False)
            |> Tuple.first
-- (以下略)
```

ここで`calculateCollisionRanges`は、それぞれのアイテムがルーレット上に占める角度の範囲(始端角\[%\]〜終端角\[%\])を計算する関数であり、次のように定義される。

```elm
calculateCollisionRanges : Counters -> Float -> List RotationRange
calculateCollisionRanges counters rotation =
  let
    counts = List.map (\counter -> toFloat counter.count) counters
    total = List.sum counts
    percentages = List.map (\count -> 100.0 * count / total) counts
    offsets =
      List.foldl (\percentage acc -> List.append acc [(Maybe.withDefault 0.0 <| List.maximum acc) + percentage]) [0.0] percentages
        |> List.map ((+) rotation)
  in
    List.map2 (\percentage offset -> RotationRange offset <| offset + percentage) percentages offsets
```

`let in`中で計算されている`offsets`は始端角\[%\]のリストであり、`percentages`はルーレット上で占める角度の範囲の大きさ\[%\]のリストである。  
これらを用いて最後の行`List.map2 (\percentage offset -> RotationRange offset <| offset + percentage) percentages offsets`で、ルーレット上に占める角度の範囲を求めている。

次に`willBeNewlyPointed`は、回転が1つ分進むことによって指定のアイテムが新たにルーレットの針で指されるようになるかどうかを計算する関数であり、以下のように定義される。  
(このアプリでは、ルーレットが回転している間、針が指しているアイテムのラベルを表示し続けるような仕様にしている。針が指すアイテムは回転が進むうちに変化するため、回転する毎に調べるように実装している。結果を知るだけであればルーレット停止時に調べれば済むのだが、今回はそれでは不十分なのだ。）

```elm
willBeNewlyPointed : Float -> RotationRange -> Bool
willBeNewlyPointed rotationVelocity collisionRange  =
  if carryDownUnder 200.0 100.0 (collisionRange.max + rotationVelocity) > 100.0
    && carryDownUnder 200.0 100.0 (collisionRange.min + rotationVelocity) <= 100
  then
    True
  else
    False

carryDownUnder : Float -> Float -> Float -> Float
carryDownUnder maximum decrementStep value =
  if value < maximum then
    value
  else
    carryDownUnder value decrementStep <| value - decrementStep
```

`willBeNewlyPointed`関数内のみにおいては、ルーレット上でのアイテムの始端角/終端角を0\[%\]〜200\[%\]で表している。(他の箇所では0\[%\]〜100\[%\]で表現している。)  
このとき、ルーレットの回転が進むことによって新たに針に指されるようになるアイテムは次の4つの条件をすべて満たす。

1. 回転が進む前の、始端角が100\[%\]以下である
2. 回転が進む前の、終端角が100\[%\]以下である
3. 回転が進んだ後の、始端角が100\[%\]以下である
4. 回転が進んだ後の、終端角が100\[%\]より大きい

ここで、条件1と2は常に成り立つので、わざわざ考慮しなくてよい。(なぜなら、「他の箇所では0\[%\]〜100\[%\]で表現している」という前提のため。回転が進む前の始端角/終端角は、「他の箇所」から渡される値。)  
よって`willBeNewlyPointed`関数は、条件3と4を満たすようなアイテム(`counter`)に対しては`True`を返し、そうでないものには`False`を返す。

ちなみに、ヘルパー関数の`carryDownUnder`は、回転角が100\[%\]以上進むような場合でも始端角/終端角を0\[%\]〜200\[%\]の範囲に収めるために用いる。

### 3.4 ルーレットの停止箇所をランダム or インチキで決定する処理

![cheat](/images/tech-blog/2018-unfair-roulette-technology/cheating.avif)

インチキでルーレットの停止箇所を決定するには、ラベルの左隣にある四角形をクリックする。  
これにより`Cheat`メッセージが送られ、以下に示すコードで`Cheat`メッセージを処理することで、ルーレットを停止させる回転角の範囲`model.cheatedGoalRange `を、クリックしたアイテム範囲に設定する。

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case (msg, model.scene) of
-- (中略)
    (Cheat counter, EditingRoulette) ->
      let
        cheatedGoalRange_ =
          if counter.count > 0 then
            calculateCollisionRanges model.counters 0.0
              |> List.take counter.id
              |> List.reverse
              |> List.head
              |> Maybe.andThen (\maybeRange -> Just <| Range (100.0 - maybeRange.max) (100.0 - maybeRange.min))
          else
            Nothing
      in
        ({model | cheatedGoalRange = cheatedGoalRange_}, Cmd.none)
```

この後「Start」ボタンがクリックされると`OnClickStart`メッセージが送られ、以下のコードに示すように、停止させる回転角の範囲(先程インチキで決めた値)内で停止角をランダムに決定する。  
このとき、もしもインチキがされていないならば、0\[%\]〜100\[%\]の範囲(コード中の`fairGoalRange`)内でランダムに停止角を決定する(つまり、フェア)。

これにより決定した停止角を`StartSpinningRoulette`メッセージで送り、ルーレットの回転が開始される。

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case (msg, model.scene) of
-- (中略)
    (OnClickStart, EditingRoulette) ->
      let
        goalRange =
          Maybe.withDefault fairGoalRange model.cheatedGoalRange
      in
        (model, Random.generate (StartSpinningRoulette initialDecayRate) <| Random.pair (Random.float initialVelocityRange.min initialVelocityRange.max) (Random.float goalRange.min goalRange.max))

    (StartSpinningRoulette decayRate_ (initialVelocity, goal), EditingRoulette) ->
      if isThereEnogthCountersToStart model.counters then
        ({ model | scene = RouletteSpinning, decayRate = decayRate_,rotationVelocity = initialVelocity, goalRotation = goal }, Cmd.none)
      else
        (model, Cmd.none)
-- (以下略)


-- ヘルパー関数: ルーレットを開始するための最低限の個数のアイテムが設定済みかどうかをチェックする
isThereEnogthCountersToStart : Counters -> Bool
isThereEnogthCountersToStart counters =
  counters
    |> List.filter (\counter -> counter.count > 0)
    |> List.length
    |> (<) 1
```

ちなみに、ルーレットの回転は サブスクリプション により定期的になされる。

```elm
subscriptions : Model -> Sub Msg
subscriptions model =
  case model.scene of
    RouletteSpinning ->
      Time.every 30 SpinRoulette
    RouletteSpinningTowardsStop ->
      Time.every 30 SpinRoulette
    _ ->
      Sub.none
```

### 3.5 ルーレットを予定された停止角で停止させる処理

ルーレットの回転を進める`SpinRoulette`メッセージを`update`関数内で処理する際、  
ルーレットの角加速度が閾値を初めて下回るような場合に、減衰係数`model.decayRate`を調整するための`AdjustDecayRateForSmoothStop`メッセージを送信する (コード掲載は省略)。

これにより減衰係数を1に近づけ、ルーレットの回転が高々あと1周だけゆっくりと続くようにする。  
このときの`SpinRoulette`メッセージの処理中で、`willReachGoal`関数によりルーレットが停止角に達するかどうかを調べ、達するようであればルーレットの回転を停止する。

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case (msg, model.scene) of
-- (中略)
    (AdjustDecayRateForSmoothStop decayRate_, RouletteSpinning) ->
      ({ model | decayRate = decayRate_, scene = RouletteSpinningTowardsStop }, Cmd.none)

    (SpinRoulette _, RouletteSpinningTowardsStop) ->
      let
        pointedCounter_ =
          calculateCollisionRanges model.counters model.rotation
            |> List.map2 (\counter collisionRange -> Tuple.pair counter <| willBeNewlyPointed model.rotationVelocity collisionRange) model.counters
            |> List.filter (\(counter, willBeNewlyPointed_) -> willBeNewlyPointed_)
            |> List.head
            |> Maybe.withDefault (model.pointedCounter, False)
            |> Tuple.first
        (rotation_, rotationVelocity_) = updateRotation model.rotation model.rotationVelocity model.decayRate
      in
        if willReachGoal model.goalRotation model.rotation model.rotationVelocity then
          update (StopRoulette milliSecondsToKeepRouletteStopUntilResult) model
        else
          ({ model | rotation = rotation_, rotationVelocity = rotationVelocity_, pointedCounter = pointedCounter_}, Cmd.none)

    (StopRoulette forMilliSeconds, RouletteSpinningTowardsStop) ->
      ({ model | scene = RouletteStopped}, Process.sleep forMilliSeconds |> Task.perform (always ShowResult))
-- (以下略)


-- ヘルパー関数: 回転が１つ進むことで予定の停止角に達するかどうかを調べる
willReachGoal : Float -> Float -> Float -> Bool
willReachGoal goal rotation velocity =
  if rotation < goal && goal <= rotation + velocity then
    True
  else
    False
```

## 4. もし作り直すなら...

この記事の残りでは、出来栄えに対する不満点、開発を振り返っての反省点を述べていく。  
未来の自分よ、気が向いたらこれを元に修正してくれ。

### 4.1 スマートフォンで使いやすいデザインにする

このアプリはPCよりもスマートフォンで利用するシーンがメインになると予想される。

しかし開発当時はPCでレイアウトを確認しながらコーディングを進めてしまい、スマートフォンで確認したのは開発が一通り終わった頃になってしまった。

スクリーンショットを見ればわかるように、スマートフォンでは小さく表示されてしまい操作しづらい。

開発終盤でレスポンシブにしようと試みたが、思うようなレイアウトにならず断念してしまった。  
むしろPCは切り捨てて、完全にモバイル用にしてしまうのでも良かったと思う。

&#x1f447;PC画面での表示
![with-pc](/images/tech-blog/2018-unfair-roulette-technology/with-pc.avif)

&#x1f447;スマートフォンでの表示
![with-mobile](/images/tech-blog/2018-unfair-roulette-technology/with-mobile.avif)

### 4.2 裏技的なコードよりも王道的なコードで書く

既に述べたように、ルーレットの描画（というよりも、扇形の描画）にはこちらの記事の方法を用いた。  
[\[Elm\] SVGで円グラフを表示する方法](https://hahnah.github.io/tech-blog/2018-elm-svg-piechart/)

この方法では時計回りに扇形を並べることで円グラフを作ることになる。  
私はコードをなるべくシンプルにするためには反時計回りに扇形を並べるべきと考えていたが、  
この方法を使いつつも反時計回りに並べようとすると、うまく表示されなかった。  
(オフセットや描画順などを泥臭く調整すれば上手くいったかもしれないが...)

SVGで描画する際の角度については反時計回りが正の回転方向なのだが、時計回りの方向に扇形を並べてしまったことで向きの不一致が起こった。このため所々に細かな調整が必要になり、コードが若干理解しづらくなってしまったし、コーディングの際に私自身が混乱した。

### 4.3 ルーレットが自然な止まり方をするようなロジックにする

このルーレットアプリは予定された停止角で停止するように終盤で角速度の減衰係数の調整を行うが、このために止まり方が不自然に見えてしまうことがある。  
(最後にしぶとく回転し続ける。)

これを解決する一案として、調整を最後に行うのではなく開始直後に行う方法がある。  
まず、ルーレットの初速度と減衰係数より調整を一切行わない場合の停止角を求め、目的としている停止角との差分を算出する。  
回転開始直後の１回目の回転進みで、回転角が丁度算出した差分の値になるように回転させる。  
(1回目の回転進みに限らず、算出した差分と回転初速度の大小関係の程度によっては、数回目としても良いと思う。)  
そこから先は減衰係数を本来の値にして回転を進める。  
すると目的としている停止角で停止し、停止の仕方も自然なものとなる。

しかし今度はルーレット回転開始直後の回転の仕方に違和感が出るのではないか？　と疑問に思うかもしれないが、  
回転開始からしばらくは角速度が大きく、また角速度が調整される時間は非常に短い(数十ミリ〜数百ミリ秒)のでほぼ違和感はないと思われる。
