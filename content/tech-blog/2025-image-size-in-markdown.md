---
title: "[Elm] Markdown記法で画像表示サイズを指定する方法"
# image: "/images/tech-blog/slug/image.jpg"
description: "Markdown記法では画像の表示サイズを指定できない場合がある。表示サイズを指定し、Markdownライブラリにそれを解析・表示させるようカスタムすることで、簡単に実現する方法を紹介する。"
published: "2025-06-04"
# updated: "2025-02-20"
category: "tech"
tags: ["elm", "markdown"]
---

## 前提

画像の表示サイズ指定というのは、HTMLでいうところの以下のような記述に相当する。

```html
<img src="/path/to/images/sample.png" width="300" height="400" />
```

自分が使っている dillonkearns/elm-markdown は `![alt](src)` の記述で画像を表示できるが、表示サイズを指定することはできない。  
Markdownライブラリの中に画像サイズを指定できるものや、`<img>`タグを直接かけるものもあるだろう。そういったものならそうすればいい。

この記事では、ElmのMarkdowonライブラリ dillonkearns/elm-markdown を使う上で、画像の表示サイズ指定を機能させる方法を紹介する。

### 環境

- 言語: Elm 0.19
- Markdownライブラリ: [dillonkearns/elm-markdown 7.0.1](https://package.elm-lang.org/packages/dillonkearns/elm-markdown/7.0.1/)

## 1. 表示サイズの指定方法を決める

以下のように、画像パスの末尾に`#width=300&height=400`のように記述することで、表示サイズを指定するものとする。  
このフォーマット、記号は自分で好きなように定められる。

```markdown
![画像です](/path/to/images/sample.png#width=300&height=400)
```

## 2. 表示サイズの解析ロジックを実装する

`/path/to/images/sample.png#width=300&height=400` という文字列から表示サイズを解析する `parseImageAttributes` を以下のとおり実装する。

```elm
import Html
import Html.Attributes

parseImageAttributes : String -> ( String, List (Html.Attribute msg) )
parseImageAttributes src =
    case String.split "#" src of
        [ base ] ->
            ( base, [] )

        base :: fragment :: _ ->
            let
                params = String.split "&" fragment

                parseParam param =
                    case String.split "=" param of
                        [ "width", val ] ->
                            String.toInt val |> Maybe.map Html.Attributes.width

                        [ "height", val ] ->
                            String.toInt val |> Maybe.map Html.Attributes.height

                        _ ->
                            Nothing
            in
            ( base, List.filterMap parseParam params )

        _ ->
            ( src, [] )
```

parseImageAttributes 関数を使うと、`/path/to/images/sample.png#width=300&height=400` のような文字列から、

```elm
( "/path/to/images/sample.png"
, [ Html.Attributes.width "300", Html.Attributes.height "400" ]
)
```

のような値を得ることができる。

## 3. 解析して得た width, height でレンダリングするように実装する

```elm
import Html exposing (Html)
import Markdown.Renderer

customImageRenderer : { alt : String, src : String, title : Maybe String } -> Html msg
customImageRenderer { alt, src, title } =
    let
        -- extraAttrsに "#width=300&height=400" の部分に対応する
        -- [ Html.Attributes.width "300", Html.Attributes.height "400" ] が入る
        (baseSrc, extraAttrs) =
            parseImageAttributes src -- ここで parseImageAttributes を使っている

        titleAttr =
            case title of
                Just t -> [ Html.Attributes.title t ]
                Nothing -> []
    in
    Html.img
        ([ Html.Attributes.src baseSrc
         , Html.Attributes.alt alt
         ]
         ++ titleAttr
         ++ extraAttrs
        )
        []

markdownRenderer : Markdown.Renderer.Renderer (Html msg)
markdownRenderer =
    { Markdown.Renderer.defaultHtmlRenderer
    | image = customImageRenderer -- ここで customImageRenderer を使っている
    }


markdownToHtml : String -> List (Html msg)
markdownToHtml markdownString =
    markdownString
        |> Markdown.Parser.parse
        |> Result.mapError (\_ -> "Markdown error.")
        |> Result.andThen
            (\blocks ->
                Markdown.Renderer.render
                    markdownRenderer -- ここで markdownRenderer を使っている
                    blocks
            )
        |> Result.withDefault [ Html.text "failed to read markdown" ]
```

`markdownToHtml` 関数を使えばMarkdown文字列をElmの `List (Html msg)` に変換できる。  
これで問題なく表示できることがわかるだろう。

## おわり

Elmの dillonkearns/elm-markdown ライブラリを使う上で、Markdown記法を拡張して画像の表示サイズを指定する方法を紹介した。  
参考になれば幸いだ。
