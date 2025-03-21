module Content.About exposing (Author, allAuthors, defaultAuthor, updatedAt)

import BackendTask exposing (BackendTask)
import BackendTask.File as File
import BackendTask.Glob as Glob
import Dict exposing (Dict)
import FatalError exposing (FatalError)
import Json.Decode as Decode


updatedAt : BackendTask FatalError (Maybe String)
updatedAt =
    defaultAuthor
        |> BackendTask.map .updated
        |> BackendTask.mapError
            (\err ->
                { fatal = FatalError.fromString "Failed to get updated date"
                , recoverable = err.recoverable
                }
            )
        |> BackendTask.allowFatal


type alias Author =
    { body : String
    , name : String
    , avatar : Maybe String
    , socials : List ( String, String )
    , occupation : Maybe String
    , company : Maybe String
    , slug : String
    , updated : Maybe String
    }


authorFiles : BackendTask error (List { filePath : String, slug : String })
authorFiles =
    Glob.succeed
        (\filePath fileName ->
            { filePath = filePath
            , slug = fileName
            }
        )
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/authors/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toBackendTask


allAuthors : BackendTask FatalError (Dict String Author)
allAuthors =
    authorFiles
        |> BackendTask.map
            (List.map
                (\file ->
                    file.filePath
                        |> File.bodyWithFrontmatter (authorDecoder file.slug)
                        |> BackendTask.map (\author -> ( author.slug, author ))
                )
            )
        |> BackendTask.resolve
        |> BackendTask.allowFatal
        |> BackendTask.map Dict.fromList


authorDecoder : String -> String -> Decode.Decoder Author
authorDecoder slug body =
    Decode.map7 (Author body)
        (Decode.field "name" Decode.string)
        (Decode.maybe <| Decode.field "avatar" Decode.string)
        (Decode.map (Maybe.withDefault []) <| Decode.maybe <| Decode.field "socials" <| Decode.keyValuePairs Decode.string)
        (Decode.maybe <| Decode.field "occupation" Decode.string)
        (Decode.maybe <| Decode.field "company" Decode.string)
        (Decode.succeed slug)
        (Decode.maybe <| Decode.field "updated" Decode.string)


defaultAuthor : BackendTask { fatal : FatalError, recoverable : File.FileReadError Decode.Error } Author
defaultAuthor =
    File.bodyWithFrontmatter (authorDecoder "default") "content/authors/default.md"
