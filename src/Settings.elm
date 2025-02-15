module Settings exposing
    ( author
    , basePath
    , baseUrl
    , copyrightYear
    , domain
    , locale
    , logoImageForSeo
    , logoUrl
    , subtitle
    , title
    , xId
    )

import Head.Seo
import LanguageTag.Language as Language
import LanguageTag.Region as Region
import Pages.Url exposing (Url)
import UrlPath


domain : String
domain =
    "hahnah.github.io"


basePath : String
basePath =
    "/"


baseUrl : String
baseUrl =
    "https://" ++ domain ++ basePath


logoUrl : Url
logoUrl =
    [ "media", "blog-image.png" ] |> UrlPath.join |> Pages.Url.fromPath


logoImageForSeo : Head.Seo.Image
logoImageForSeo =
    { url = logoUrl
    , alt = "logo"
    , dimensions = Just { width = 500, height = 333 }
    , mimeType = Nothing
    }


locale : Maybe ( Language.Language, Region.Region )
locale =
    Just ( Language.en, Region.us )


title : String
title =
    "Hahnah's elm-pages Blog Template"


subtitle : String
subtitle =
    "A blog template created with elm-pages and TailwindCSS by Hahnah (Natsuki Harai)."


author : String
author =
    "Hahnah"


copyrightYear : String
copyrightYear =
    "2025"


xId : Maybe String
xId =
    -- or like Just "@superhahnah"
    Nothing
