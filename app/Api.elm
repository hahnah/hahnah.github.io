module Api exposing (manifest, routes)

import ApiRoute exposing (ApiRoute)
import BackendTask exposing (BackendTask)
import Content.About
import Content.AllBlogpost
import Content.Apps
import Content.BlogpostCommon exposing (Status(..))
import Content.LifeBlogpost
import Content.TechBlogpost
import FatalError exposing (FatalError)
import Html exposing (Html)
import Iso8601
import Layout.Index
import Pages
import Pages.Manifest as Manifest
import Route exposing (Route(..))
import Settings
import Sitemap


routes :
    BackendTask FatalError (List Route)
    -> (Maybe { indent : Int, newLines : Bool } -> Html Never -> String)
    -> List (ApiRoute ApiRoute.Response)
routes getStaticRoutes _ =
    [ sitemap <| makeSitemapEntries getStaticRoutes ]



-- Manifest


manifest : Manifest.Config
manifest =
    Manifest.init
        { name = Settings.title
        , description = Settings.subtitle
        , startUrl = Route.Index |> Route.toPath
        , icons = Settings.symbolsForManifest
        }



-- Sitemap


sitemap :
    BackendTask FatalError (List Sitemap.Entry)
    -> ApiRoute.ApiRoute ApiRoute.Response
sitemap entriesSource =
    ApiRoute.succeed
        (entriesSource
            |> BackendTask.map
                (\entries ->
                    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                        ++ Sitemap.build { siteUrl = Settings.baseUrl } entries
                )
        )
        |> ApiRoute.literal "sitemap.xml"
        |> ApiRoute.single


makeSitemapEntries : BackendTask FatalError (List Route) -> BackendTask FatalError (List Sitemap.Entry)
makeSitemapEntries getStaticRoutes =
    let
        build route =
            let
                routeSource lastMod =
                    BackendTask.succeed
                        { path = String.join "/" (Route.routeToPath route)
                        , lastMod = lastMod
                        }
            in
            case route of
                Index ->
                    Just <| routeSource <| Just <| Layout.Index.updatedAt

                About ->
                    Just <|
                        BackendTask.andThen routeSource <|
                            BackendTask.map identity Content.About.updatedAt

                Apps ->
                    Just <| routeSource <| Just <| Content.Apps.updatedAt

                Blog ->
                    Just <|
                        BackendTask.andThen routeSource <|
                            BackendTask.map
                                (\blogposts ->
                                    blogposts
                                        |> List.map (\post -> Iso8601.fromTime <| Content.BlogpostCommon.getLastModified post.metadata)
                                        |> List.maximum
                                )
                                Content.AllBlogpost.allBlogposts

                TechBlog ->
                    Just <|
                        BackendTask.andThen routeSource <|
                            BackendTask.map
                                (\blogposts ->
                                    blogposts
                                        |> List.map (\post -> Iso8601.fromTime <| Content.BlogpostCommon.getLastModified post.metadata)
                                        |> List.maximum
                                )
                                Content.TechBlogpost.allBlogposts

                TechBlog__Slug_ routeParams ->
                    Just <|
                        BackendTask.andThen routeSource <|
                            BackendTask.map
                                (\blogposts ->
                                    case List.filter (\post -> post.metadata.slug == routeParams.slug) blogposts of
                                        post :: _ ->
                                            Just <| Iso8601.fromTime <| Content.BlogpostCommon.getLastModified post.metadata

                                        [] ->
                                            Just <| Iso8601.fromTime <| Pages.builtAt
                                )
                                Content.TechBlogpost.allBlogposts

                LifeBlog ->
                    Just <|
                        BackendTask.andThen routeSource <|
                            BackendTask.map
                                (\blogposts ->
                                    blogposts
                                        |> List.map (\post -> Iso8601.fromTime <| Content.BlogpostCommon.getLastModified post.metadata)
                                        |> List.maximum
                                )
                                Content.LifeBlogpost.allBlogposts

                LifeBlog__Slug_ routeParams ->
                    Just <|
                        BackendTask.andThen routeSource <|
                            BackendTask.map
                                (\blogposts ->
                                    case List.filter (\post -> post.metadata.slug == routeParams.slug) blogposts of
                                        post :: _ ->
                                            Just <| Iso8601.fromTime <| Content.BlogpostCommon.getLastModified post.metadata

                                        [] ->
                                            Just <| Iso8601.fromTime <| Pages.builtAt
                                )
                                Content.LifeBlogpost.allBlogposts

                Tags ->
                    Just <| BackendTask.andThen routeSource <| BackendTask.succeed <| Nothing

                Tags__Slug_ _ ->
                    Just <| routeSource <| Nothing
    in
    getStaticRoutes
        |> BackendTask.map (List.filterMap build)
        |> BackendTask.resolve
