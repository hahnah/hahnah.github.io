module Layout.Apps exposing (view)

import Content.Apps exposing (App)
import Html exposing (Html)
import Html.Attributes as Attrs
import Route


view : List App -> List (Html msg)
view apps =
    [ Html.div
        [ Attrs.class "divide-y divide-gray-200 dark:divide-gray-700"
        ]
        [ Html.div
            [ Attrs.class "space-y-2 pb-8 pt-6 md:space-y-5"
            ]
            [ Html.h1
                [ Attrs.class "text-3xl font-extrabold leading-9 tracking-tight text-gray-900 dark:text-gray-100 sm:text-4xl sm:leading-10 md:text-6xl md:leading-14"
                ]
                [ Html.text "Hahnah's Apps" ]
            ]
        , Html.div
            [ Attrs.class "flex flex-wrap justify-center my-8 gap-8"
            ]
            (List.map appVeiw apps)
        ]
    ]


appVeiw : App -> Html msg
appVeiw app =
    Html.div
        [ Attrs.class "w-full h-32 flex flex-row rounded-xl shadow-md bg-white dark:bg-gray-900 relative"
        ]
        [ Html.div
            [ Attrs.class "flex justify-center items-center border-t-1 border-gray-200 dark:border-gray-800 rounded-l-xl overflow-hidden bg-gray-200 dark:bg-gray-800 w-32 h-32 min-w-[128px] "
            ]
            [ Html.img
                [ Attrs.src app.imagePath
                , Attrs.alt app.name
                , Attrs.class "w-full h-full"
                ]
                []
            ]
        , Html.div
            [ Attrs.class "px-2 w-full flex flex-col gap-1 justify-end rounded-r-xl border-t-1 border-r-1 border-gray-200 dark:border-gray-800"
            ]
            [ Html.h2
                [ Attrs.class "mt-2 text-xl md:text-2xl font-semibold text-gray-900 dark:text-gray-100"
                ]
                [ Html.text app.name ]
            , Html.p
                [ Attrs.class "text-base md:text-lg leading-none text-gray-600 dark:text-gray-400"
                ]
                [ Html.text app.description ]
            , Html.div [ Attrs.class "mt-auto mb-2 flex gap-1 sm:gap-3" ]
                [ case app.documentSlug of
                    Just slug ->
                        Route.link
                            [ Attrs.class "rounded-full px-4 bg-rose-300 hover:bg-rose-500 dark:bg-rose-200 dark:hover:bg-rose-50 text-sm md:text-base text-white dark:text-gray-500 z-1"
                            ]
                            [ Html.text "Doc" ]
                            (Route.TechBlog__Slug_ { slug = slug })

                    Nothing ->
                        Html.text ""
                , case app.technologySlug of
                    Just slug ->
                        Route.link
                            [ Attrs.class "rounded-full px-4 bg-teal-400 hover:bg-teal-600 dark:bg-teal-300 dark:hover:bg-fuchsia-50 text-sm md:text-base text-white dark:text-gray-500 z-1"
                            ]
                            [ Html.text "Tech" ]
                            (Route.TechBlog__Slug_ { slug = slug })

                    Nothing ->
                        Html.text ""
                , case app.codeUrl of
                    Just url ->
                        Html.a
                            [ Attrs.href url
                            , Attrs.target "_blank"
                            , Attrs.rel "noopener noreferrer"
                            , Attrs.class "rounded-full px-4 bg-fuchsia-300 hover:bg-fuchsia-500 dark:bg-fuchsia-200 dark:hover:bg-fuchsia-50 text-sm md:text-base text-white dark:text-gray-500 z-1"
                            ]
                            [ Html.text "Code" ]

                    Nothing ->
                        Html.text ""
                ]
            ]
        , if app.isAvailable then
            Html.a
                [ Attrs.href app.url
                , Attrs.target "_blank"
                , Attrs.rel "noopener noreferrer"
                , Attrs.class "absolute inset-0 z-0"
                ]
                []

          else
            Html.div
                [ Attrs.class "absolute inset-0 z-0 flex justify-center items-center bg-gray-800 text-4xl sm:text-7xl text-white  opacity-40 sm:opacity-20"
                ]
                [ Html.text "Unavailable" ]
        ]
