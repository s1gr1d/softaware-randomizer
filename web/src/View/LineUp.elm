module View.LineUp exposing (..)

import Css exposing (..)
import Html.Styled exposing (Html, div, img, text)
import Html.Styled.Attributes exposing (css, src)
import Html.Styled.Events exposing (onClick)
import Message exposing (Msg(..))
import Model.Types exposing (..)
import View.Player exposing (renderPlayerRounded)


renderLineUp : Maybe LineUp -> Html Msg
renderLineUp optionalLineUp =
    case optionalLineUp of
        Nothing ->
            text ""

        Just lineUp ->
            div
                [ onClick ClearLineUp
                , css
                    [ position Css.absolute
                    , Css.width (Css.vw 100)
                    , Css.height (Css.vh 100)
                    , Css.backgroundColor (Css.rgba 0 0 0 0.4)
                    , Css.zIndex (Css.int 100)
                    , Css.displayFlex
                    ]
                ]
                [ div
                    [ css
                        [ Css.backgroundColor (Css.hex "ffffff")
                        , Css.width (Css.vw 90)
                        , Css.left (Css.vw 5)
                        , Css.alignSelf Css.center
                        , Css.position Css.relative
                        , Css.boxShadow5 Css.zero (Css.px 12) (Css.px 15) Css.zero (Css.rgba 0 0 0 0.24)
                        ]
                    ]
                    [ img
                        [ src "./assets/lineup.png"
                        , css
                            [ Css.paddingTop (Css.rem 2.5)
                            , Css.height (Css.rem 3)
                            , Css.property "object-fit" "contain"
                            , Css.display Css.block
                            , Css.margin2 Css.zero Css.auto
                            ]
                        ]
                        []
                    , div [ css [ Css.padding (Css.rem 2) ] ]
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
    img
        [ src "./assets/soccer-table.png"
        , css
            [ Css.width (Css.pct 100)
            , Css.margin2 (Css.rem 0.5) Css.zero
            , Css.property "object-fit" "contain"
            ]
        ]
        []
