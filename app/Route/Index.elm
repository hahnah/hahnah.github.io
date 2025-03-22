module Route.Index exposing (ActionData, Data, Model, Msg, RouteParams, route)

import BackendTask exposing (BackendTask)
import Content.BlogpostCommon exposing (Metadata)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Layout.Index
import PagesMsg exposing (PagesMsg)
import RouteBuilder exposing (App, StatelessRoute)
import Settings
import Shared
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
        { canonicalUrlOverride = Nothing
        , siteName = Settings.title
        , image = Settings.symbolAndLogoForSeo
        , description = Settings.subtitle
        , locale = Settings.locale
        , title = Settings.title
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app _ =
    { title = Settings.title
    , body = Layout.Index.view app.data.blogpostMetadata
    }
