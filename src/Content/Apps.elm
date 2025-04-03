module Content.Apps exposing (App, allApps, updatedAt)


updatedAt : String
updatedAt =
    "2025-03-25T00:00:00.000Z"


type alias App =
    { name : String
    , description : String
    , imagePath : String
    , url : String
    , documentSlug : Maybe String
    , technologySlug : Maybe String
    , codeUrl : Maybe String
    , isAvailable : Bool
    }


allApps : List App
allApps =
    [ { name = "Color Stew"
      , description = "カラースキーマの理論に基づいて美しいカラーパレットの作成を補助します。"
      , imagePath = "/images/apps/color-stew.avif"
      , url = "https://hahnah.github.io/color-stew/"
      , documentSlug = Just "2019-color-stew"
      , technologySlug = Just "2019-color-stew-technology"
      , codeUrl = Just "https://github.com/hahnah/color-stew"
      , isAvailable = True
      }
    , { name = "Unfair Roulette"
      , description = "悪用厳禁！出目を思いのままに操作できるルーレットです。"
      , imagePath = "/images/apps/unfair-roulette.avif"
      , url = "https://hahnah.github.io/unfair-roulette/"
      , documentSlug = Just "2018-unfair-roulette"
      , technologySlug = Just "2018-unfair-roulette-technology"
      , codeUrl = Just "https://github.com/hahnah/unfair-roulette"
      , isAvailable = True
      }
    ]
