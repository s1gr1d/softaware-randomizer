module View.LineUp exposing (..)

import Css exposing (..)
import Html exposing (Html, div)
import Html.Attributes
import Html.Events
import Message exposing (Msg(ClearLineUp))
import Model.Types exposing (..)
import View.Common exposing (styles)
import View.Player exposing (renderPlayerRounded)


renderLineUp : Maybe LineUp -> Html Msg
renderLineUp optionalLineUp =
    case optionalLineUp of
        Nothing ->
            Html.text ""

        Just lineUp ->
            div
                [ Html.Events.onClick ClearLineUp
                , styles
                    [ Css.position Css.absolute
                    , Css.width (Css.vw 100)
                    , Css.height (Css.vh 100)
                    , Css.backgroundColor (Css.rgba 0 0 0 0.4)
                    , Css.zIndex (Css.int 100)
                    , Css.displayFlex
                    ]
                ]
                [ div
                    [ styles
                        [ Css.backgroundColor (Css.hex "ffffff")
                        , Css.width (Css.vw 90)
                        , Css.left (Css.vw 5)
                        , Css.alignSelf Css.center
                        , Css.position Css.relative
                        , Css.boxShadow5 Css.zero (Css.px 12) (Css.px 15) Css.zero (Css.rgba 0 0 0 0.24)
                        ]
                    ]
                    [ Html.img
                        [ Html.Attributes.src "./assets/lineup.png"
                        , styles
                            [ Css.paddingTop (Css.rem 2.5)
                            , Css.height (Css.rem 3)
                            , Css.property "object-fit" "contain"
                            , Css.display Css.block
                            , Css.margin2 Css.zero Css.auto
                            ]
                        ]
                        []
                    , div [ styles [ Css.padding (Css.rem 2) ] ]
                        [ case lineUp of
                            Single single ->
                                div []
                                    [ renderPlayerRounded single.player1 [ Css.marginLeft (Css.pct 54) ]
                                    , soccerTable
                                    , renderPlayerRounded single.player2 [ Css.marginLeft (Css.pct 23) ]
                                    ]

                            Double double ->
                                div []
                                    [ renderPlayerRounded double.teamA.player2 [ Css.marginLeft (Css.pct 34) ]
                                    , renderPlayerRounded double.teamA.player1 [ Css.marginLeft (Css.pct 13) ]
                                    , soccerTable
                                    , renderPlayerRounded double.teamB.player1 [ Css.marginLeft (Css.pct 8) ]
                                    , renderPlayerRounded double.teamB.player2 [ Css.marginLeft (Css.pct 14) ]
                                    ]
                        ]
                    ]
                ]


soccerTable : Html Msg
soccerTable =
    Html.img
        [ Html.Attributes.src "./assets/soccer-table.png"
        , styles
            [ Css.width (Css.pct 100)
            , Css.margin2 (Css.rem 0.5) Css.zero
            , Css.property "object-fit" "contain"
            ]
        ]
        []
