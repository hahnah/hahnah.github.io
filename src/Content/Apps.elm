module Content.Apps exposing (allApps, updatedAt)


updatedAt : String
updatedAt =
    "2025-03-22T00:00:00.000Z"


type alias App =
    { name : String
    , description : String
    , url : String
    , imagePath : String
    , category : List String
    }


allApps : List App
allApps =
    []
