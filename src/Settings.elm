module Settings exposing
    ( author
    , basePath
    , baseUrl
    , copyrightYear
    , domain
    , locale
    , subtitle
    , symbolAndLogoForSeo
    , symbolAndLogoPath
    , symbolAndLogoUrl
    , symbolPath
    , symbolsForManifest
    , title
    , xId
    )

import Head.Seo
import LanguageTag.Language as Language
import LanguageTag.Region as Region
import MimeType exposing (MimeImage)
import Pages.Manifest as Manifest
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


symbolPath : String
symbolPath =
    "/images/symbols-and-logos/symbol.svg"


symbolAndLogoPath : String
symbolAndLogoPath =
    "/images/symbols-and-logos/symbol-and-logo.png"


symbolAndLogoUrl : Url
symbolAndLogoUrl =
    [ "images", "symbols-and-logos", "symbol-and-logo.png" ] |> UrlPath.join |> Pages.Url.fromPath


symbolAndLogoForSeo : Head.Seo.Image
symbolAndLogoForSeo =
    { url = symbolAndLogoUrl
    , alt = "symbol"
    , dimensions = Just { width = 500, height = 333 }
    , mimeType = Nothing
    }


symbolsForManifest : List Manifest.Icon
symbolsForManifest =
    let
        webpMimeType : MimeImage
        webpMimeType =
            MimeType.OtherImage "image/webp"

        purposes : List Manifest.IconPurpose
        purposes =
            [ Manifest.IconPurposeAny, Manifest.IconPurposeMaskable ]
    in
    [ { src = [ "images", "symbols-and-logos", "symbol-192x192.png" ] |> UrlPath.join |> Pages.Url.fromPath
      , sizes = [ ( 192, 192 ) ]
      , mimeType = Just MimeType.Png
      , purposes = purposes
      }
    , { src = [ "images", "symbols-and-logos", "symbol-192x192.webp" ] |> UrlPath.join |> Pages.Url.fromPath
      , sizes = [ ( 192, 192 ) ]
      , mimeType = Just webpMimeType
      , purposes = purposes
      }
    , { src = [ "images", "symbols-and-logos", "symbol-512x512.png" ] |> UrlPath.join |> Pages.Url.fromPath
      , sizes = [ ( 512, 512 ) ]
      , mimeType = Just MimeType.Png
      , purposes = purposes
      }
    , { src = [ "images", "symbols-and-logos", "symbol-512x512.webp" ] |> UrlPath.join |> Pages.Url.fromPath
      , sizes = [ ( 512, 512 ) ]
      , mimeType = Just webpMimeType
      , purposes = purposes
      }
    ]


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
