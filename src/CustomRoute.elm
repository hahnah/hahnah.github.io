module CustomRoute exposing (linkWithTrailingSlash)

import Html
import Html.Attributes
import Route


linkWithTrailingSlash : List (Html.Attribute msg) -> List (Html.Html msg) -> Route.Route -> Html.Html msg
linkWithTrailingSlash attributes children route =
    toLink (\anchorAttrs -> Html.a (anchorAttrs ++ attributes) children) route


toLink : (List (Html.Attribute msg) -> abc) -> Route.Route -> abc
toLink toAnchorTag route =
    toAnchorTag
        [ Html.Attributes.href (toString route)
        , Html.Attributes.attribute "elm-pages:prefetch" ""
        ]


toString : Route.Route -> String
toString route =
    ensureTrailingSlash (Route.toString route)


ensureTrailingSlash : String -> String
ensureTrailingSlash url =
    if String.endsWith "/" url || url == "/" then
        url

    else
        url ++ "/"
