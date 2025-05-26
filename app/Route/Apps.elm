module Route.Apps exposing (ActionData, Data, Model, Msg, RouteParams, route)

import BackendTask exposing (BackendTask)
import Content.Apps
import Content.BlogpostCommon exposing (Metadata)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Layout.Apps
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
    {}


type alias Data =
    { blogpostMetadata : List Metadata
    }


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


data : BackendTask FatalError Data
data =
    BackendTask.succeed { blogpostMetadata = [] }


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head _ =
    Seo.summaryLarge
        { canonicalUrlOverride = Route.Apps |> Route.toPath |> UrlPath.toRelative |> (\path -> Settings.baseUrl ++ path ++ "/") |> Just
        , siteName = Settings.title
        , image = Settings.symbolAndLogoForSeo
        , description = "Apps created by Natsuki Harai"
        , locale = Settings.locale
        , title = "Hahnah's Apps"
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view _ _ =
    { title = Settings.title
    , body = Layout.Apps.view Content.Apps.allApps
    }
