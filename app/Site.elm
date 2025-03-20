module Site exposing (config)

import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Head
import Settings
import SiteConfig exposing (SiteConfig)


config : SiteConfig
config =
    { canonicalUrl = Settings.baseUrl
    , head = head
    }


head : BackendTask FatalError (List Head.Tag)
head =
    [ Head.metaName "viewport" (Head.raw "width=device-width,initial-scale=1")
    , Head.sitemapLink "/sitemap.xml"
    , Head.metaName "google-site-verification" (Head.raw "4bSyz5M2yG7qbbOk3bDplOhLgLDDf7v0i06U_8-OzdY")
    ]
        |> BackendTask.succeed
