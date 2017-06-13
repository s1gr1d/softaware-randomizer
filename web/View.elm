module View exposing (..)

import Css
import Html exposing (Attribute, Html, button, div, img, li, option, p, select, text, ul)
import Html.Attributes exposing (alt, class, disabled, selected, size, src)
import Html.Events exposing (on, onClick)
import Material.Spinner as Loading
import Message exposing (Msg(ClearLineUp, Randomize, SelectionChanged))
import Model exposing (Model)


styles : List Css.Mixin -> Attribute msg
styles =
    Css.asPairs >> Html.Attributes.style


selectionOpacity : Model.Selectable Model.Player -> List Css.Mixin
selectionOpacity selectable =
    selectionToVisibility selectable.selected


selectionToVisibility : Bool -> List Css.Mixin
selectionToVisibility selected =
    [ Css.opacity
        (Css.num
            (if selected then
                1
             else
                0.47
            )
        )
    ]


playerColumns : Int
playerColumns =
    4


playerPadding : Float
playerPadding =
    5


renderPlayer : Model.Selectable Model.Player -> Html Msg
renderPlayer selectable =
    li
        [ styles
            ([ Css.property "width" ("calc(" ++ toString (100 // playerColumns) ++ "% - " ++ toString (2 * playerPadding) ++ "px)")
             , Css.margin (Css.px playerPadding)
             , Css.position Css.relative
             ]
                ++ selectionOpacity selectable
            )
        ]
        [ case selectable.object of
            Model.Employee employee ->
                renderEmployee employee

            Model.Guest guest ->
                renderGuest guest
        ]


renderEmployee : Model.EmployeeInfo -> Html Msg
renderEmployee employee =
    img
        [ styles [ Css.maxWidth (Css.pct 100), Css.maxHeight (Css.pct 100) ]
        , src employee.pictureUrl
        , alt employee.firstName
        , onClick (SelectionChanged (Model.Employee employee))
        ]
        []


renderGuest : Model.GuestInfo -> Html Msg
renderGuest guest =
    img
        [ styles [ Css.maxWidth (Css.pct 100), Css.maxHeight (Css.pct 100) ]
        , src ("./assets/guest-" ++ toString guest.number ++ ".png")
        , alt ""
        , onClick (SelectionChanged (Model.Guest guest))
        ]
        []


white : Css.Color
white =
    Css.hex "ffffff"


pct100 : Css.Pct
pct100 =
    Css.pct 100


header : Html Msg
header =
    Html.header [ styles [ Css.backgroundColor (Css.hex "f9f9f9"), Css.padding (Css.vh 2.2), Css.displayFlex, Css.justifyContent Css.center, Css.alignItems Css.center, Css.boxShadow4 Css.zero (Css.px 3) (Css.px 6) (Css.rgba 0 0 0 0.17) ] ]
        [ img [ styles [ Css.height (Css.vh 3) ], src "./assets/randomzr.png" ] []
        ]


view : Model -> Html Msg
view model =
    div [ styles [ Css.boxSizing Css.borderBox, Css.height (Css.vh 100), Css.width (Css.vw 100) ] ]
        [ errorMessage model.error
        , lineUp model.lineUp
        , div [ styles [ Css.displayFlex, Css.flexDirection Css.column ] ]
            [ header
            , Loading.spinner
                [ Loading.active model.loading ]
            , ul [ styles [ Css.listStyleType Css.none, Css.margin (Css.rem 1), Css.padding Css.zero, Css.displayFlex, Css.flexWrap Css.wrap, Css.justifyContent Css.center ] ]
                (List.map renderPlayer (Model.orderedPlayers model))
            , button
                [ disabled (not (Model.isRandomizable model))
                , onClick Randomize
                , styles
                    [ Css.alignSelf Css.center
                    , Css.margin (Css.rem 2.5)
                    , Css.backgroundColor (Css.rgb 119 179 0)
                    , Css.color white
                    , Css.textTransform Css.uppercase
                    , Css.border Css.zero
                    , Css.fontSize (Css.rem 1.5)
                    , Css.padding2 (Css.rem 1) (Css.rem 4)
                    , Css.borderRadius (Css.px 2)
                    , Css.boxShadow5 Css.zero (Css.px 2) (Css.px 5) Css.zero (Css.rgba 0 0 0 0.26)
                    , Css.property "transition" "box-shadow 0.2s cubic-bezier(0.4, 0, 0.2, 1)"
                    , Css.hover
                        [ Css.color (Css.hex "ff0000")
                        , Css.boxShadow5 Css.zero (Css.px 8) (Css.px 17) Css.zero (Css.rgba 0 0 0 0.2)
                        ]
                    ]
                ]
                [ text "Randomize" ]
            ]
        ]


lineUp : Maybe Model.LineUp -> Html Msg
lineUp optionalLineUp =
    case optionalLineUp of
        Nothing ->
            Html.text ""

        Just lineUp ->
            div
                [ onClick ClearLineUp
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
                        [ Css.backgroundColor white
                        , Css.width (Css.vw 80)
                        , Css.left (Css.vw 10)
                        , Css.alignSelf Css.center
                        , Css.position Css.relative
                        , Css.boxShadow5 Css.zero (Css.px 12) (Css.px 15) Css.zero (Css.rgba 0 0 0 0.24)
                        ]
                    ]
                    [ Html.img
                        [ src "./assets/lineup.png"
                        , styles
                            [ Css.padding (Css.rem 2.5)
                            , Css.height (Css.rem 3)
                            , Css.property "object-fit" "contain"
                            , Css.display Css.block
                            , Css.margin2 Css.zero Css.auto
                            ]
                        ]
                        []
                    , div [ styles [ Css.padding (Css.rem 1) ] ]
                        [ case lineUp of
                            Model.Single single ->
                                div []
                                    [ Html.text (Model.displayName single.player1)
                                    , Html.img
                                        [ src "./assets/soccer-table.jpg"
                                        , styles
                                            [ Css.width (Css.pct 100)
                                            , Css.property "object-fit" "contain"
                                            ]
                                        ]
                                        []
                                    , Html.text (Model.displayName single.player2)
                                    ]

                            Model.Double double ->
                                div []
                                    [ Html.text (Model.displayName double.teamA.player1 ++ "&" ++ Model.displayName double.teamA.player2)
                                    , Html.img
                                        [ src "./assets/soccer-table.jpg"
                                        , styles
                                            [ Css.width (Css.pct 100)
                                            , Css.property "object-fit" "contain"
                                            ]
                                        ]
                                        []
                                    , Html.text (Model.displayName double.teamB.player1 ++ "&" ++ Model.displayName double.teamB.player2)
                                    ]
                        ]
                    ]
                ]


errorMessage : Maybe Model.Error -> Html Msg
errorMessage error =
    case error of
        Nothing ->
            div [] []

        _ ->
            div []
                [ text (toString error) ]
