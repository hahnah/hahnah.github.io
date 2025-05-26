module Route.LifeBlog.Slug_ exposing (ActionData, Data, Model, Msg, RouteParams, route)

import BackendTask exposing (BackendTask)
import Content.BlogpostCommon exposing (Blogpost)
import Content.LifeBlogpost
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Layout.LifeBlogpost
import Pages.Url
import PagesMsg exposing (PagesMsg)
import Route
import RouteBuilder exposing (App, StatelessRoute)
import Settings
import Shared
import UrlPath
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    { slug : String }


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.preRender
        { head = head
        , pages = pages
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


pages : BackendTask FatalError (List RouteParams)
pages =
    Content.LifeBlogpost.allBlogposts
        |> BackendTask.map
            (\blogposts ->
                List.map (\{ metadata } -> { slug = metadata.slug }) blogposts
            )


type alias Data =
    { blogpost : Blogpost
    }


type alias ActionData =
    {}


data : RouteParams -> BackendTask FatalError Data
data routeParams =
    BackendTask.map Data
        (Content.LifeBlogpost.blogpostFromSlug routeParams.slug)


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    let
        imagePath =
            app.data.blogpost.metadata.image
                |> Maybe.withDefault Settings.symbolAndLogoPath

        creatorHeader =
            case Settings.xId of
                Just xId ->
                    [ Head.metaName "twitter:creator" <| Head.raw xId ]

                Nothing ->
                    []

        authorsHeader =
            case app.data.blogpost.metadata.authors of
                [] ->
                    []

                [ author ] ->
                    [ Head.metaName "twitter:label1" <| Head.raw "Author"
                    , Head.metaName "twitter:data1" <| Head.raw author.name
                    ]

                authors ->
                    [ Head.metaName "twitter:label1" <| Head.raw "Authors"
                    , Head.metaName "twitter:data1" <| Head.raw <| String.join ", " <| List.map .name authors
                    ]
    in
    (Seo.summaryLarge
        { canonicalUrlOverride = Route.LifeBlog__Slug_ { slug = app.data.blogpost.metadata.slug } |> Route.toPath |> UrlPath.toRelative |> (\path -> Settings.baseUrl ++ path ++ "/") |> Just
        , siteName = Settings.title
        , image =
            { url = Pages.Url.fromPath [ imagePath ]
            , alt = app.data.blogpost.metadata.title
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = Maybe.withDefault Settings.subtitle app.data.blogpost.metadata.description
        , locale = Settings.locale
        , title = app.data.blogpost.metadata.title
        }
        |> Seo.article
            { tags = app.data.blogpost.metadata.tags
            , section = Nothing
            , publishedTime = app.data.blogpost.metadata.publishedAt
            , modifiedTime = app.data.blogpost.metadata.updatedAt
            , expirationTime = Nothing
            }
    )
        ++ creatorHeader
        ++ authorsHeader


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app _ =
    { title = app.data.blogpost.metadata.title
    , body = [ Layout.LifeBlogpost.viewBlogpost app.data.blogpost ]
    }
