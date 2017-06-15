module View exposing (..)

import Css exposing (..)
import Dict
import Html exposing (Html, button, div, img, text)
import Html.Attributes
import Html.Events
import Material.Spinner as Loading
import Message exposing (Msg(Randomize))
import Model exposing (Model)
import Model.Getters as Get
import Model.Types exposing (..)
import View.Common exposing (styles)
import View.LineUp exposing (renderLineUp)
import View.Player exposing (renderPlayerSelectable)


header : Html Msg
header =
    Html.header
        [ styles
            [ backgroundColor (hex "f9f9f9")
            , displayFlex
            , justifyContent center
            , alignItems center
            , boxShadow4 zero (px 3) (px 6) (rgba 0 0 0 0.17)
            ]
        ]
        [ img
            [ styles
                [ Css.padding (Css.rem 1)
                , Css.height (Css.rem 1.7)
                ]
            , Html.Attributes.src "./assets/randomzr.png"
            ]
            []
        ]


errorMessage : Maybe Error -> Html Msg
errorMessage error =
    case error of
        Nothing ->
            div [] []

        _ ->
            div []
                [ Html.text (toString error) ]


view : Model -> Html Msg
view model =
    div [ styles [ boxSizing borderBox, height (vh 100), width (vw 100) ] ]
        [ errorMessage model.error
        , renderLineUp model.lineUp
        , div [ styles [ displayFlex, flexDirection column ] ]
            [ header
            , Loading.spinner
                [ Loading.active model.loading ]
            , div
                [ styles
                    [ listStyleType none
                    , margin (Css.rem 1)
                    , padding zero
                    , displayFlex
                    , flexWrap wrap
                    , justifyContent center
                    , alignItems start
                    ]
                ]
                (List.map renderPlayerSelectable (model.players |> Dict.values))
            , button
                [ Html.Attributes.disabled (not (Get.isRandomizable model))
                , Html.Events.onClick Randomize
                , styles
                    [ alignSelf center
                    , margin (Css.rem 1)
                    , backgroundColor
                        (if Get.isRandomizable model then
                            rgb 119 179 0
                         else
                            rgb 200 200 200
                        )
                    , color (hex "ffffff")
                    , textTransform uppercase
                    , border zero
                    , fontSize (Css.rem 1)
                    , padding2 (Css.rem 1) (Css.rem 4)
                    , borderRadius (px 2)
                    , boxShadow5 zero (px 2) (px 5) zero (rgba 0 0 0 0.26)
                    , property "transition" "box-shadow 0.2s cubic-bezier(0.4, 0, 0.2, 1)"
                    , hover
                        [ color (hex "ff0000")
                        , boxShadow5 zero (px 8) (px 17) zero (rgba 0 0 0 0.2)
                        ]
                    ]
                ]
                [ Html.text "Randomize" ]
            ]
        ]
