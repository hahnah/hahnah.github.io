module Layout.Index exposing (updatedAt, view)

import Content.BlogpostCommon exposing (Metadata)
import Html exposing (Html)
import Html.Attributes as Attrs
import Phosphor
import Route
import Settings


updatedAt : String
updatedAt =
    "2025-02-16T00:00:00Z"


view : List Metadata -> List (Html msg)
view blogpostMetadata =
    [ Html.div [ Attrs.class "space-y-6 md:space-y-8 pb-8 pt-6" ]
        [ Html.div [ Attrs.class "flex justify-center" ] [ Route.link [] [ author ] Route.About ]
        , Html.h1 [ Attrs.class "flex justify-center text-3xl font-extrabold leading-8 tracking-tight text-gray-900 dark:text-gray-100 md:text-6xl md:leading-14" ] [ Html.text Settings.title ]
        , Html.p [ Attrs.class "flex justify-center text-lg leading-10 text-gray-600 dark:text-gray-400" ] [ Html.text Settings.subtitle ]
        , Html.div [ Attrs.class "flex flex-wrap justify-center gap-x-8 gap-y-8" ] [ appsLink, codeLink, blogLink ]
        ]
    ]


author : Html msg
author =
    Html.img
        [ Attrs.src "/images/authors/natsuki-harai.jpg"
        , Attrs.alt "Natsuki Harai"
        , Attrs.width 144
        , Attrs.height 144
        , Attrs.class "rounded-full"
        ]
        []


appsLink : Html msg
appsLink =
    Route.link
        [ Attrs.class "flex gap-2 justify-center items-center bg-sky-500 hover:bg-sky-600 rounded-full w-full py-3 md:w-auto md:px-10"
        ]
        [ Phosphor.appStoreLogo Phosphor.Regular
            |> Phosphor.withClass "fill-current text-white h-8 w-8"
            |> Phosphor.toHtml []
        , Html.div [ Attrs.class "text-2xl font-semibold text-white align-middle" ] [ Html.text "Apps" ]
        ]
        -- TODO: Replace with apps route
        Route.About


codeLink : Html msg
codeLink =
    Html.a
        [ Attrs.href Settings.githubUrl
        , Attrs.class "flex gap-2 justify-center items-center bg-gray-900 hover:bg-gray-600 rounded-full w-full py-3 md:w-auto md:px-10"
        ]
        [ Phosphor.githubLogo Phosphor.Regular
            |> Phosphor.withClass "fill-current text-white h-8 w-8"
            |> Phosphor.toHtml []
        , Html.div [ Attrs.class "text-2xl font-semibold text-white align-middle" ] [ Html.text "Code" ]
        ]


blogLink : Html msg
blogLink =
    Route.link
        [ Attrs.class "flex gap-2 justify-center items-center bg-teal-500 hover:bg-teal-600 rounded-full w-full py-3 md:w-auto md:px-10"
        ]
        [ Phosphor.books Phosphor.Regular
            |> Phosphor.withClass "fill-current text-white h-8 w-8"
            |> Phosphor.toHtml []
        , Html.div [ Attrs.class "text-2xl font-semibold text-white align-middle" ] [ Html.text "Blog" ]
        ]
        Route.Blog
