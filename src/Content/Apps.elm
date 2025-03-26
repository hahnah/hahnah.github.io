module Content.Apps exposing (App, allApps, updatedAt)


updatedAt : String
updatedAt =
    "2025-03-25T00:00:00.000Z"


type alias App =
    { name : String
    , description : String
    , imagePath : String
    , url : String
    , documentUrl : Maybe String
    , technologyUrl : Maybe String
    , codeUrl : Maybe String
    , isAvailable : Bool
    }


allApps : List App
allApps =
    [ { name = "Color Stew"
      , description = "カラースキーマの理論に基づいて美しいカラーパレットの作成を補助します。"
      , imagePath = "/images/apps/color-stew.avif"
      , url = "https://hahnah.github.io/color-stew/"
      , documentUrl = Just "/tech-blog/2019-color-stew"
      , technologyUrl = Just "/tech-blog/2019-color-stew-technology"
      , codeUrl = Just "https://github.com/hahnah/color-stew"
      , isAvailable = True
      }
    ]
