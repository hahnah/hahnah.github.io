---
title: "[Elm] Color Stew という Webアプリを作った話"
image: "/images/tech-blog/2019-color-stew-technology/color-stew-screen.avif"
description: "Color Stew というデザイン用のWebアプリを作った。この記事では作る際の苦労や所感を紹介する。"
published: "2019-08-18"
updated: "2025-03-26"
category: "tech"
tags: ["color-stew", "indie-app", "design", "color-theory", "elm"]
---

アプリの概要や使い方は以下の記事で紹介している。  
[https://hahnah.github.io/tech-blog/2019-color-stew](https://hahnah.github.io/tech-blog/2019-color-stew)

## 開発に用いた言語やツールなど

- Elm 0.19: 言語/フレームワークとして。
- elm-format: Elm用のフォーマッター。
- elm-live: Dev Server を立ててくれるやつ。Elmのコードを変更すると自動でページリロードされるので便利。
- elm-ui: ElmでUIを組み立てやすくする Elmパッケージ。
- dnd-list: ドラッグ&ドロップのための Elmパッケージ。
- elm-color, elm-color-extra: 色関連の Elmパッケージ。

[Color Stew のソースコードはこちら (記事執筆時点の Color Stew 1.0.0)。](https://github.com/hahnah/color-stew/tree/1.0.0)

以下、苦労した実装の説明がしばらく続く。  
最後に所感を述べる。

## カラーピッカーの実装

### ゴール

ユーザーがカラーピッカーから１色を選択し、その色を状態に保持する(elm-colorのrColor`型の値として)。

### アプローチ

`<input type="color">`に相当するもを実装し、カラーピッカーからユーザーが1つの色を選択するようにした。

```elm
            Element.html
                (Html.input
                    [ Element.Attributes.type_ "color"
                    , Element.Attributes.value <| Color.Convert.colorToHex model.pickedColor
                    , Element.Events.onInput PickColor
                    ]
                    []
                )
```

ユーザーが色を選択すると例えば`PickColor "#ffffff"`といったようなメッセージが送られる。  
上記に現れる(elm-color-extra の)`Color.Convert.colorToHex`関数は、`Color`型の値を`String`型の16進カラーコードへと変換してくれる。

`update`関数では、elm-color-extraの`Color.Convert.hexToColor`関数を使うことで elm-colorの`Color`型の値に変換し、状態(`model.pickedColor`)を更新する。

```elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PickColor colorHex ->
            ( { model
                | pickedColor =
                    case Color.Convert.hexToColor colorHex of
                        Ok color ->
                            color

                        Err _ ->
                            model.pickedColor
              }
            , Cmd.none
            )
-- (他caseは省略)
```

## 色空間の変換

### ゴール

以下の3つの用途にそれぞれ合った色空間で色を表現できるように、変換する方法を用意すること。

- カラーピッカーのための色空間
- elm-ui で着色するための色空間
- カラースキーム生成のための色空間

### アプローチ

#### カラーピッカーのための色空間 へ/から 変換する

既に触れているが、カラーピッカーの値は`String`型であり、HEX(16進カラーコード)である。

`Color`型の値を HEX へ変換するには`Color.Convert.colorToHex`関数を、  
逆に HEX を `Color`型へ変換するには`Color.Convert.hexToColor`関数を使えば良い。

#### elm-ui で着色するための色空間 へ 変換する

elm-ui で配色するためには、**elm-ui の**`Element.Color`値が求められる。`Element.Color`値を作るには、その色の RGB もしくは RGBA 空間での値が必要となる。

elm-color-extra の`Color.Convert.colorToCssRgb`関数を使えば、`"rgb(255, 0, 0)"`といった具合に RGB 空間での値を文字列で得られるが、R, G, B の各値を取り出すために Parser を用いる。  
すると、次の`toElmUIColor`関数のようにして`Element.Color`への変換ができる。

```elm
toElmUIColor : Color -> Element.Color
toElmUIColor color =
    let
        colorRgb_ : Result (List DeadEnd) Rgb
        colorRgb_ =
            color
                |> Color.Convert.colorToCssRgb
                |> Parser.run rgb
    in
    case colorRgb_ of
        Ok colorRgb ->
            Element.rgb (colorRgb.r / 255) (colorRgb.g / 255) (colorRgb.b / 255)

        Err _ ->
            toElmUIColor defaultColor -- 何かしらのデフォルト色


type alias Rgb =
    { r : Float
    , g : Float
    , b : Float
    }


rgb : Parser Rgb
rgb =
    succeed Rgb
        |. symbol "rgb("
        |= float
        |. symbol ","
        |. spaces
        |= float
        |. symbol ","
        |. spaces
        |= float
        |. symbol ")"
```

ちなみに、逆方向の変換は利用シーンがないので実装しない。

#### カラースキーム生成のための色空間 へ/から 変換する

まずは、カラースキーム生成のためにはどの色空間を使えばよいのかを考えてみる。  
Color Stew で生成するカラースキームは以下のとおりである:

- Monochromatic (Shades ともいう)
- Dyad (Complementary ともいう)
- Triad
- Compound (Split Complementary ともいう)
- Tetrad
- Pentad
- 上記カラースキームに明るい色や暗い色を加えたもの

Monochromatic の生成にはベースカラーに対して明度を変えた色を作れば良く、  
また、Dyad/Triad/Compound/Tetrad/Pentad の生成にはベースカラーに対して色相を変えた色を作れば良い。  
明るい色/暗い色というのは、単にベースカラーの明度を調整した色とする。

よって、色相と明度を指定して色を生成したいので、それらを扱えるような色空間であればよいとわかる。  
となると、候補としては HSL や HSB(HSV) などが挙がる。

[elm-color](https://package.elm-lang.org/packages/avh4/elm-color/latest) というパッケージの `Color` 型なら HSL色空間を扱えるので、これを使う。  
(elm-color というパッケージは複数あるが、ここでは avh4/elm-color のこと。)  
ちなみにHSLというのは、H: Hue(色相)、S: Saturation(彩度)、L: Lightness(明度) をそれぞれ表す。

ここまでで既に登場しているが、HSL、RGB、HEX(16進カラーコード)間の変換のために [elm-color-extra](https://package.elm-lang.org/packages/noahzgordon/elm-color-extra/latest/) というパッケージも使う。

`Color`値から HSL の値への変換は RGB のときと同様で、`Color.Convert.colotToCssHsl`関数とParserを使い、H, S, L の各値を取り出すようにした。

```elm
type alias Hsl =
    { h : Float
    , s : Float
    , l : Float
    }


hsl : Parser Hsl
hsl =
    succeed Hsl
        |. symbol "hsl("
        |. spaces
        |= float
        |. symbol ","
        |. spaces
        |= float
        |. symbol "%,"
        |. spaces
        |= float
        |. symbol "%)"
```

例えば以下のように使えばよい。

```elm
    color
        |> Color.Convert.colorToCssHsl
        |> Parser.run hsl
```

また、`Hsl`型の値から`Color`型の値を作るには、定義域の違いを考慮して次のようにする。

```elm
-- 前提として、 hsl_ : Hsl の値とする

Color.hsl (hsl_.h / 360) (hsl_.s / 100) (hsl_.l / 100)
```

#### 補足

ここまで、`Color`から RGB や HSL の値を取り出すために、`Color.Convert.colorToCssXxx`と Parser を組み合わせて実装したが、  
よく見ると avh4/elm-color には`Color.toRgba`、`Color.toHsla`関数があり、これらを使えば Parser なしでもっと単純にできたはず。

しかしこのおかげで Elm の Parser に初めて触れれたので後悔はない。  
もし今後 Color Stew のバージョンアップがあれば合わせてリファクタリングしたい。

**P.S.** [リファクタリングした。150行ほど短くなった。](https://github.com/hahnah/color-stew/commit/7bdb06c848b62891ce9032b5ab418d8c0b8d0737)

## カラースキーム自動生成機能の実装

### ゴール

ユーザーが決めたベースカラーをもとにして、Color Stew が次のカラースキームを自動生成する:

- Monochromatic (Shades ともいう)
  - 明度だけが異なるような色の組み合わせ
- Dyad (Complementary ともいう)
  - 色相環を2等分するように並んだ色の組み合わせ。すべての色が同一彩度、同一明度。
- Triad
  - 色相環を3等分するように並んだ色の組み合わせ。すべての色が同一彩度、同一明度。
- Compound (Split Complementary ともいう)
  - ベースカラーと、色相環上で対極の位置から前後に少し(今回は&plusmn;30°とした)だけずらした色の組み合わせ。すべての色が同一彩度、同一明度。
- Tetrad (Tetrad ではなく Square と呼ぶ場合もあるらしい)
  - 色相環を4等分するように並んだ色の組み合わせ。すべての色が同一彩度、同一明度。
- Pentad
  - 色相環を5等分するように並んだ色の組み合わせ。すべての色が同一彩度、同一明度。
- 上記カラースキームに明るい色や暗い色を加えたもの
  - Dyad + ベースカラーの明度を下げた/上げた色の組み合わせ など

![hues](/images/tech-blog/2019-color-stew-technology/hues.avif)

### アプローチ

ベースカラーに対して Hue(色相) と Lightness(明度) を変えた色を作ることで、カラースキームを自動生成する。

まずは、色相環間を m 等分したときのベースカラーの n 個隣に位置する色を計算する関数`pickNthNext`を作る。

例えば`pickNthNext baseColor 2 1`とすると、  
`baseColor`(Color値) を基準として色相環を2等分したときの、ベースカラーの1つ隣の色(つまり baseColorと合わせて Dyad を構成するような色) が得られる。

```elm
pickNthNext : Color -> Int -> Int -> Result (List DeadEnd) Color
pickNthNext baseColor total n =
    let
        hueDifferenceUnit : Float
        hueDifferenceUnit =
            1 / toFloat total

        baseColorHslWithDegreeHue : Result (List DeadEnd) Hsl
        baseColorHslWithDegreeHue =
            baseColor
                |> Color.Convert.colorToCssHsl
                |> Parser.run hsl

        baseColorHsl : Result (List DeadEnd) Hsl
        baseColorHsl =
            case baseColorHslWithDegreeHue of
                Ok colorHsl ->
                    Ok
                        {- Change HSL formart from {h: 0-360[deg], s: 0-100[%], l: 0-100[%]} to {h: 0-1, s: 0-1, l: 0-1} -}
                        { colorHsl
                            | h = colorHsl.h / 360
                            , s = colorHsl.s / 100
                            , l = colorHsl.l / 100
                        }

                Err msg ->
                    Err msg
    in
    case baseColorHsl of
        Ok colorHsl ->
            let
                gainedHue =
                    colorHsl.h + toFloat n * hueDifferenceUnit

                pickedHue =
                    if gainedHue >= 1 then
                        gainedHue - 1

                    else
                        gainedHue
            in
            Ok <| Color.hsl pickedHue colorHsl.s colorHsl.l

        Err _ ->
            Err [ DeadEnd 1 1 <| Parser.Problem "Failed pickNthNext" ]
```

Dyad を得るには、`pickNthNext baseColor 2 0`と`pickNthNext baseColor 2 1`を合わせればよいし、  
Triad ならば `pickNthNext baseColor 3 0`と`pickNthNext baseColor 3 1`と`pickNthNext baseColor 3 2`を組み合わせればできる。  
それを組み合わせてカラースキームを返してくれる関数`pickPolyad`を作る。

```elm
pickPolyad : Color -> Int -> List Color
pickPolyad baseColor dimension =
    List.range 0 (dimension - 1)
        |> List.map (pickNthNext baseColor dimension)
        |> List.foldr
            (\resultColor ->
                \acc ->
                    case resultColor of
                        Ok color ->
                            color :: acc

                        Err _ ->
                            acc
            )
            []
```

Dyad: `pickPolyad baseColor 2`  
Triad: `pickPolyad baseColor 3`  
Tetrad: `pickPolyad baseColor 4`  
Pentad: `pickPolyad baseColor 5`  
その先の Hexad なんかを作りたくなったときも、`pickPolyad baseColor 6`とすればできる。

ちなみに Compound は`pickPolyad`で作れない。  
`baseColor`,`pickNthNext color 12 5`,`pickNthNext color 12 7`を組み合わせる。

また、Monochromatic については`baseColor`の明度を等差(20%とした)で変化させて作成するものとした。

```elm
pickMonochromatic : Color -> List Color
pickMonochromatic baseColor =
    let
        baseColorHsl : Result (List DeadEnd) Hsl
        baseColorHsl =
            baseColor
                |> Color.Convert.colorToCssHsl
                |> Parser.run hsl

        makeOverflow : Float -> Float -> Float
        makeOverflow num max =
            if num <= max then
                num

            else
                num - max
    in
    case baseColorHsl of
        Ok colorHsl ->
            List.range 0 4
                |> List.map toFloat
                |> List.map (\index -> Hsl (colorHsl.h / 360) (colorHsl.s / 100) (makeOverflow (colorHsl.l / 100 + index * 0.2) 1))
                |> List.sortBy .l
                |> List.map (\hsl_ -> Color.hsl hsl_.h hsl_.s hsl_.l)

        Err _ ->
            []
```

## クリップボードへのコピー機能の実装

### ゴール

ユーザーがボタンを押すと、カラーコードがクリップボードへコピーされる。

### アプローチ

この機能を実装には、**Port** を用いて JavaScript を利用した。  
ここでは Port の基本的な使い方は割愛するが、JavaScript側のコードは次のようにし、受け取った任意の文字列をクリップボードへコピーするようになっている。Elm側ではその文字列にカラーコードを指定する。

```javascript
const app = Elm.Main.init({
  node: document.getElementById("elm-node"),
});

app.ports.copyString.subscribe((str) => {
  let tempDiv = document.createElement("div");
  let tempPre = document.createElement("pre");
  tempDiv.appendChild(tempPre).textContent = str;
  tempDiv.style.position = "fixed";
  tempDiv.style.right = "200%";
  document.body.appendChild(tempDiv);
  document.getSelection().selectAllChildren(tempDiv);
  document.execCommand("copy");
  document.body.removeChild(tempDiv);
});
```

```elm
-- Elm側 copyString
port copyString : String -> Cmd msg
```

JavaScript で`document.execCommand('copy');`とすることで、選択されている文字列がクリップボードにコピーされる。**コピーしたい文字列が選択されている必要がある**というのが、面倒な点だ。  
このために、受け取った文字列`str`をもつDOM要素を画面外に作成し、その文字列を` document.getSelection().selectAllChildren(tempDiv);`で選択した後に`document.execCommand('copy');`でコピーしている。最後にこのDOM要素を削除する。

## ドラッグ&ドロップによる配色変更機能の実装

### ゴール

プレビューのどの領域をどの色で着色するか。というのは、Color Stew の右下に並ぶ色の順番で決まる。例えば、「背景とタイトルの色を入れ替えたい」という場合には、左から1番目と2番目の色をドラッグ&ドロップで入れ替えるように操作する。

![color-order](/images/tech-blog/2019-color-stew-technology/color-stew-color-oder.avif)

### アプローチ

この実装には [dnd-list](https://package.elm-lang.org/packages/annaghi/dnd-list/latest/) というパッケージを利用した。

dnd-list は、ドラッグ&ドロップしたい対象のデータ構造が **List** である場合に使うことが想定されたパッケージだ。ドラッグ&ドロップ操作の結果に合わせて、ソート済みの List を作ってくれる。  
Elmにはドラッグ&ドロップのためのパッケージはいくつかあるが、今回はまさに dnd-list が威力を発揮するケースだったのでこれを採用した。また、dnd-list は [サンプル](https://annaghi.github.io/dnd-list/) がとても豊富でわかりやすいので簡単に試せた。

[このサンプルコード](https://annaghi.github.io/dnd-list/introduction/basic) を参考に実装しただけなので、特筆するものはない。

## 所感

**elm-ui は良い。**  
elm-ui を使うのは初めてだったが、CSS弱者の私でも簡単に思い通りのレイアウトが組めてしまった。elm-ui では`row`と`column`を使って縦/横に画面分割していくようなレイアウトの組み方が基本になるのだが、この考え方が結構好きかもしれない。また普通のCSSと比べて、あるレイアウトを実現するために指定しなければならない属性の組み合わせや値が、elm-ui ではより単純になっていて私にとってはストレスが少なかった。CSS弱者の私にとっては CSSは思い通りに扱えないことが多いが、elm-ui は明快で使っていて楽しい。何というか、ピッタリはまる感じがする。  
Color Stew では CSS を一切使っていないが、カーソルホバー時の背景色変更なんかは、CSSでやったほうが良さそう。本記事では触れていない実装だが、今回はマウスイベントを拾って updateで状態更新・viewで背景色をグレーにするような実装をしている。これだけの処理をそのためだけに記述するのも面倒なので、CSS と適切に併用したいと思った。**(追記: あとで知ったが elm-ui の`Element.mouseOver`でも簡単にホバー時の色変更を設定できるので、どちらでもいいかも。もしアニメーションつける場合は CSS の方が面倒な状態管理なく楽に実装できると思う。)**  
elm-ui は楽しくレイアウトを組めて個人的には好きになったが、不満点もある。elm-ui の`Elemet.Color`は機能が貧弱という点だ。`Element.Color`は実際、RGB(A)の値からしか作成できなかったり、RGB(A)値への変換にしか対応していなかったりしていたため、Color Stew の実装では他のパッケージで HEX や HSL に対応するはめになった。(ただ、HEX や HSL のニーズってどれくらいあるの? というのはよく知らないので、elm-ui の欠点とまで言うつもりはない。)

**elm-live も良い。**  
elm reactor と違い、更新してもリロードボタンを押す必要がなくなる。それだけなのだが、これが結構楽に感じる。  
ただし elm-live を起動したままの状態で Mac をシャットダウンしようとすると、ターミナルが終了されなくて Mac を強制終了するはめになったので、そこだけは注意だ (バージョンが関係あるのか分からないが elm-live 3.4.1 での話)。

**dnd-list も良い。**  
とにかくサンプルが豊富な点はすばらしく、dnd-list を使ったドラッグ&ドロップの実装は簡単だった。  
ただしタッチイベントはサポートしていない(dnd-list 5.0.0時点)ようで、モバイルデバイス(iPhone/iPadで試した)ではドラッグ&ドロップ(っていうの?)が機能しなかった。  
なのでモバイルデバイスでは Color Stew の一部機能が使えない。  
ちなみにタッチイベントをサポートしている Elmパッケージとしては [elm-pointer-events](https://package.elm-lang.org/packages/mpizenberg/elm-pointer-events/latest) があるようだ。

**Color Stew は良い?**  
私はデザインについてほとんど何も知らないレベルなので、今回取り扱った Triad や Compound などがどれほど役立つものなのかよく知らないし、存在を知ったのもつい最近のことだ。「デザインに無知な自分に役立つかもしれない」 という思いから Color Stew を作ってみたので、しばらく自分で使ってみたいと思う。  
自分のデザイン知識がアップデートされたら Color Stew もアップデートするかも。
