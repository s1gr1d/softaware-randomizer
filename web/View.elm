module View exposing (..)

import Css
import Dict
import Html exposing (Attribute, Html, button, div, img, li, option, select, text, ul)
import Html.Attributes exposing (alt, class, selected, size, src)
import Html.Events exposing (on, onClick)
import Message exposing (Msg(Randomize, SelectionChanged))
import Model exposing (Model)


styles : List Css.Mixin -> Attribute msg
styles =
    Css.asPairs >> Html.Attributes.style


disabled : Model.Player -> List Css.Mixin
disabled player =
    case player of
        Model.Employee emp ->
            selectionToVisibility emp.selected

        Model.Guest guest ->
            selectionToVisibility guest.selected


selectionToVisibility : Bool -> List Css.Mixin
selectionToVisibility selected =
    [ Css.opacity
        (Css.num
            (if selected then
                1
             else
                0.35
            )
        )
    ]


renderPlayer : Model.Player -> Html Msg
renderPlayer player =
    li [ styles ([ Css.width (Css.pct 23), Css.margin (Css.px 4) ] ++ disabled player) ]
        [ case player of
            Model.Employee employee ->
                renderEmployee employee

            Model.Guest guest ->
                renderGuest guest
        , div [ class "overlay" ] []
        ]


renderEmployee : Model.Selectable Model.EmployeeInfo -> Html Msg
renderEmployee employee =
    img
        [ styles [ Css.maxWidth (Css.pct 100), Css.maxHeight (Css.pct 100) ]
        , src employee.object.pictureUrl
        , alt employee.object.firstName
        , onClick (SelectionChanged (Model.Employee employee))
        ]
        []


renderGuest : Model.Selectable Model.GuestInfo -> Html Msg
renderGuest guest =
    img [ styles [ Css.maxWidth (Css.pct 100), Css.maxHeight (Css.pct 100) ], src "./assets/guest.png", alt "" ] []


view : Model -> Html Msg
view model =
    div []
        [ errorMessage model.error
        , ul [ styles [ Css.listStyleType Css.none, Css.margin Css.zero, Css.padding Css.zero, Css.displayFlex, Css.flexWrap Css.wrap, Css.justifyContent Css.center ] ]
            (List.map renderPlayer (Dict.values model.players))
        , button [ onClick Randomize ] [ text "Randomize" ]
        ]


errorMessage : Maybe Model.Error -> Html Msg
errorMessage error =
    case error of
        Nothing ->
            div [] []

        _ ->
            div []
                [ text (toString error) ]
