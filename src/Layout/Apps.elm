module Layout.Apps exposing (view)

import Content.BlogpostCommon exposing (Metadata)
import Html exposing (Html)
import Html.Attributes as Attrs


view : List Metadata -> List (Html msg)
view _ =
    [ Html.div [ Attrs.class "mt-28" ]
        [ Html.h1 [ Attrs.class "flex justify-center text-3xl font-extrabold leading-8 tracking-tight text-gray-900 dark:text-gray-100 md:text-6xl md:leading-14" ] [ Html.text "Apps comming soon..." ]
        ]
    ]
