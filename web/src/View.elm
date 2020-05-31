module View exposing (..)

import Bootstrap.Spinner as Spinner exposing (spinner)
import Browser
import Css exposing (..)
import Dict
import Html.Attributes exposing (style)
import Html.Styled exposing (Html, button, div, header, img, text)
import Html.Styled.Attributes exposing (css, disabled, src)
import Html.Styled.Events exposing (onClick)
import Message exposing (Msg(..))
import Model exposing (Model)
import Model.Getters as Get
import Model.Types exposing (..)
import View.LineUp exposing (renderLineUp)
import View.Player exposing (renderPlayerSelectable)


styledHeader : Html Msg
styledHeader =
    header
        [ css
            [ backgroundColor (hex "f9f9f9")
            , padding (vh 2.2)
            , displayFlex
            , justifyContent center
            , alignItems center
            , boxShadow4 zero (px 3) (px 6) (rgba 0 0 0 0.17)
            ]
        ]
        [ img [ css [ height (vh 3) ], src "./assets/randomzr.png" ] []
        ]


errorMessage : Maybe Error -> Html Msg
errorMessage error =
    case error of
        Nothing ->
            div [] []

        _ ->
            div []
                [ text (Debug.toString error) ]


view : Model -> Browser.Document Msg
view model =
    let
        body =
            div [ css [ boxSizing borderBox, height (vh 100), width (vw 100) ] ]
                [ errorMessage model.error
                , renderLineUp model.lineUp
                , div [ css [ displayFlex, flexDirection column ] ]
                    [ styledHeader
                    , Html.Styled.fromUnstyled
                        (let
                            customStyles =
                                if model.loading then
                                    []

                                else
                                    [ style "display" "none" ]
                         in
                         spinner [ Spinner.attrs customStyles ] []
                        )
                    , div
                        [ css
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
                        [ Html.Styled.Attributes.disabled (not (Get.isRandomizable model))
                        , onClick Randomize
                        , css
                            [ alignSelf center
                            , margin (Css.rem 2.5)
                            , backgroundColor
                                (if Get.isRandomizable model then
                                    rgb 119 179 0

                                 else
                                    rgb 200 200 200
                                )
                            , color (hex "ffffff")
                            , textTransform uppercase
                            , border zero
                            , fontSize (Css.rem 1.5)
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
                        [ text "Randomize" ]
                    ]
                ]
    in
    { body = [ Html.Styled.toUnstyled body ]
    , title = "softaware gmbh | rndmzr"
    }
