---
title: "[Elm] WIP の elm-3d-scene を使ってみる -- 物理演算編"
# image: "/images/tech-blog/slug/image.jpg"
description: "elm-3d-scene を使って 3DCGプログラミングをやってみた記録。今回は物理演算を実装する。"
published: "2020-05-06"
updated: "2025-06-13"
category: "tech"
tags: ["elm", "3d-cg", "physics"]
---

&darr; の記事の続きをやっていく。

[\[Elm\] WIP の elm-3d-scene を使ってみる](https://hahnah.github.io/tech-blog/2019-try-wip-elm-3d-scene/)

前回は3Dの物体を描画するだけの実装をした。  
メッシュ、物体、カメラ、光源を用意して、静的な風景を描画した。

今回はそれに加え、物理演算することを試みる。  
完成形はこんな感じだ。

![完成図](/images/tech-blog/2020-try-wip-elm-3d-scene-vol2/demo.gif)

必要なことは以下の通り。

1. もろもろの型を変える
   前回の実装に対し、物理演算を使うにあたって型を変えるべき値があるので変更していく
2. 物体に質量を与える
   物体が衝突したときの振る舞いに質量が影響するので適当に質量を設定する
3. 物理演算と状態管理をする
   一定時間ごとに物理演算し、その結果を状態管理する

結果から言うと、前回との差分は次のコミットのようになる。  
[https://github.com/hahnah/try-elm-3d-scene/commit/db08367c11447e35c226a38f4f3eb757e89d6c94](https://github.com/hahnah/try-elm-3d-scene/commit/db08367c11447e35c226a38f4f3eb757e89d6c94)

## 1. もろもろの型を変える

物理演算を使うにあたって型を変えるべき値があるので変更していく。

ちなみに、前回から追加でこの辺のモジュールがインポートされている。

```elm
import Acceleration
import Block3d
import Browser.Events
import Duration
import Frame3d
import List
import Mass
import Physics.Body as Body exposing (Body)
import Physics.Coordinates exposing (BodyCoordinates, WorldCoordinates)
import Physics.World as World exposing (World)
import Sphere3d
```

### 1-1. メッシュの型を変える

`floorMesh`の型は次のように変える。`sphereMesh`と`blockMesh`も同様。

`floorMesh : Mesh World (Triangles WithNormals NoUV NoTangents ShadowsDisabled)`  
　&dArr;  
`floorMesh : Mesh BodyCoordinates (Triangles WithNormals NoUV NoTangents ShadowsDisabled)`

### 1-2. 物体の型を変える

`floor` は次の型に変える。

`floor : Drawable World`  
　&dArr;  
`floor : Body (Drawable BodyCoordinates)`

型に合わせて中身も少し書き換える必要がある。

```elm
floor : Drawable World
floor =
    Drawable.physical whitePlastic floorMesh
        |> Drawable.translateBy (Vector3d.meters 0 0 -4)
```

&dArr; Body (Drawable BodyCoordinates) 型へ

```elm
floor : Body (Drawable BodyCoordinates)
floor =
    Drawable.physical whitePlastic floorMesh
        |> Body.plane
        |> Body.translateBy (Vector3d.meters 0 0 -4)
```

`Body.plane` に喰わせることで`Body`に適応した平面となる。  
平行移動には`Drawable.translateBy`ではなく`Body.translateBy`を使う。

`aluminumSphere`だと以下のようにする。

```elm
aluminumSphere : Drawable World
aluminumSphere =
    Drawable.physical aluminum sphereMesh
        |> Drawable.withShadow sphereMesh
        |> Drawable.translateBy (Vector3d.meters 0 0 -0.5)
```

&dArr; Body (Drawable BodyCoordinates) 型へ

```elm
aluminumSphere : Body (Drawable BodyCoordinates)
aluminumSphere =
    Drawable.physical aluminum sphereMesh
        |> Drawable.withShadow sphereMesh
        |> Body.sphere (Sphere3d.atOrigin (meters 0.8))
        |> Body.translateBy (Vector3d.meters 0 0 -0.5)
```

残りの物体である`alminumBlock`も`alminumSphere`と同様にできる。

### 1-3. カメラとライトの型を変える

カメラとライトの型を変えることも忘れずに。

`camera : Camera3d Meters World`  
　&dArr;  
`camera : Camera3d Meters WorldCoordinates`

`sunlight : Light World`  
　&dArr;  
`sunlight : Light WorldCoordinates`

`ambientLighting : AmbientLighting World`  
　&dArr;  
`ambientLighting : AmbientLighting WorldCoordinates`

## 2. 物体に質量を与える

物理演算するには質量が欠かせない。  
`alminumSphere`と`alminumBlock`に質量を与えてやろう。

`Body.setBehavior`関数で質量を持った物体を作る。  
(以下のコードの最後の行を書き足すだけ)

```elm
aluminumSphere : Body (Drawable BodyCoordinates)
aluminumSphere =
    Drawable.physical aluminum sphereMesh
        |> Drawable.withShadow sphereMesh
        |> Body.sphere (Sphere3d.atOrigin (meters 0.8))
        |> Body.translateBy (Vector3d.meters 0 0 -0.5)
        |> Body.setBehavior (Body.dynamic (Mass.kilograms 2.5))
```

`alminumBlock`も同様。

ちなみに`floor`には質量の設定をしない。  
`Body.plane`で作られたこの床はスタティックな平面であり、他の物体とは違って力が作用しても一切動かない。

## 3. 物理演算と状態管理をする

ここまでで物理演算するための型変換をして、大方の準備ができた。  
あとは一定時間ごとに物理演算をして、それを Model で管理すればいい。

### 3.1 世界を状態管理する -- Model

重力加速度は地球上での値とした(`9.80665`)。

```elm
type alias Model =
    { world : World (Drawable BodyCoordinates) }

init : () -> ( Model, Cmd Msg )
init _ =
    ( { world = initialWorld }
    , Cmd.none
    )

initialWorld : World (Drawable BodyCoordinates)
initialWorld =
    let
        gravity =
            Acceleration.metersPerSecondSquared 9.80665
    in
    World.empty
        |> World.setGravity gravity Direction3d.negativeZ
        |> World.add floor
        |> World.add aluminumSphere
        |> World.add aluminumBlock
```

### 3.2 一定時間ごとに物理演算する -- Update, Subscription

`World.simulate`関数に、進める時間、現在のWorldを与えることで、物理演算後のWorldが得られる。これを一定時間ごとに繰り返す。

```elm
type Msg
    = Tick Float

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =	update msg model =
    case msg of
        Tick _ ->
            ( { world = World.simulate (Duration.seconds (1 / 60)) model.world }
            , Cmd.none
            )

subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onAnimationFrameDelta Tick
```

### 3.3 物理演算された世界を描画する -- View

```elm
view : Model -> Html Msg
view model =
    Scene3d.render []
        { ambientLighting = Just ambientLighting
        , lights = Scene3d.oneLight sunlight { castsShadows = True }
        , camera = camera
        , width = pixels 1024
        , height = pixels 768
        , exposure = Exposure.fromEv100 14
        , whiteBalance = Chromaticity.daylight
        }
        [ aluminumSphere
        , aluminumBlock
        , floor
        ]
```

&dArr;

```elm
view : Model -> Html Msg
view model =
    Scene3d.render []
        { ambientLighting = Just ambientLighting
        , lights = Scene3d.oneLight sunlight { castsShadows = True }
        , camera = camera
        , width = pixels 1024
        , height = pixels 768
        , exposure = Exposure.fromEv100 14
        , whiteBalance = Chromaticity.daylight
        }
        List.map getTransformedDrawable (World.getBodies model.world)

getTransformedDrawable : Body (Drawable BodyCoordinates) -> Drawable WorldCoordinates
getTransformedDrawable body =
    Drawable.placeIn (Body.getFrame3d body) (Body.getData body)
```

## ここまでのデモ

[デモはこちら (https://hahnah.github.io/try-elm-3d-scene/dynamic)](https://hahnah.github.io/try-elm-3d-scene/dynamic)

## 初期位置を少しずらして完成

上記のデモでは、球体とブロックのxy座標が一致しているため、球体の上にブロックが乗った状態でバランスがとれている。

もう少し動きが見たいので、ブロックの初期位置をほんの少しだけずらしてバランスが崩れるようにする。

```elm
aluminumBlock : Body (Drawable BodyCoordinates)
aluminumBlock =
    Drawable.physical aluminum blockMesh
        |> Drawable.withShadow blockMesh
        |> Body.block (Block3d.centeredOn Frame3d.atOrigin ( meters 0.9, meters 0.9, meters 0.9 ))
        -- |> Body.translateBy (Vector3d.meters 0 0 2) ★もともとこれだったのをずらした
        |> Body.translateBy (Vector3d.meters 0.1 0 2)
        |> Body.setBehavior (Body.dynamic (Mass.kilograms 5))
```

これにて完成!!

[完成版のデモはこちら (https://hahnah.github.io/try-elm-3d-scene/dynamic2)](https://hahnah.github.io/try-elm-3d-scene/dynamic2)

## おわりに

前回・今回と elm-3d-schene を使って単純な3DCGと物理演算をやった。  
実装は elm-3d-schene の examples のひとつを参考にしている。  
([https://github.com/ianmackenzie/elm-3d-scene/blob/b184dd9f0fbb90ec194c1bd065353fa5357c5712/examples/BallsAndBlocks.elm](https://github.com/ianmackenzie/elm-3d-scene/blob/b184dd9f0fbb90ec194c1bd065353fa5357c5712/examples/BallsAndBlocks.elm))

物理演算自体は elm-physic がやってくれるので、世界や物体を定義するだけで割と簡単に実装できた。  
力を加える処理なんかを実装できれば、簡単なゲームだって作れそうだ。
