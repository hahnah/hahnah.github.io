module Content.Apps exposing (App, allApps, updatedAt)


updatedAt : String
updatedAt =
    "2025-04-05T00:00:00.000Z"


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
    [ { name = "MemoriaR"
      , description = "動画を、飾れる思い出に"
      , imagePath = "/images/apps/memoriar.avif"
      , url = "https://apps.apple.com/jp/app/memoriar/id6751318419"
      , documentSlug = Just "2026-memoriar-ja"
      , technologySlug = Nothing
      , codeUrl = Nothing
      , isAvailable = True
      },
      { name = "Color Stew"
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
    , { name = "Game of Life"
      , description = "ライフゲームと呼ばれる、生命集団の盛衰シミュレーションを見て楽しむものです。"
      , imagePath = "/images/apps/game-of-life.avif"
      , url = "https://hahnah.github.io/Elm-GameOfLife/"
      , documentSlug = Nothing
      , technologySlug = Nothing
      , codeUrl = Just "https://github.com/hahnah/Elm-GameOfLife"
      , isAvailable = True
      }
    , { name = "AR Photoplay"
      , description = "写真を飾るかのように動画を飾ろう。AR技術を使った革新的なムービーアルバムです。"
      , imagePath = "/images/apps/ar-photoplay.avif"
      , url = ""
      , documentSlug = Just "2019-ar-photoplay"
      , technologySlug = Just "2019-arkit-dev-knowledge"
      , codeUrl = Nothing
      , isAvailable = False
      }
    , { name = "Flex Camera"
      , description = "自由な形でiPhoneの動画撮影を。正方形の動画も細長い動画も思いのままに。"
      , imagePath = "/images/apps/flex-camera.avif"
      , url = ""
      , documentSlug = Just "2019-flex-camera"
      , technologySlug = Just "2019-swift-flexible-av-capture"
      , codeUrl = Just "https://github.com/hahnah/FlexCamera"
      , isAvailable = False
      }
    ]
