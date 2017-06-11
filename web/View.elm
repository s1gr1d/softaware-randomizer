module View exposing (..)

import Html exposing (Attribute, Html, button, div, img, li, option, select, text, ul)
import Html.Attributes exposing (alt, class, selected, size, src)
import Html.Events exposing (on, onClick)
import Message exposing (Msg(Randomize, SelectionChanged))
import Model exposing (Model)


renderPlayer : Model.Player -> Html Msg
renderPlayer player =
    li []
        [ case player of
            Model.Employee employee ->
                renderEmployee employee

            Model.Guest guest ->
                renderGuest guest
        , div [ class "overlay" ] []
        ]


renderEmployee : Model.Selectable Model.EmployeeInfo -> Html Msg
renderEmployee employee =
    img [ src employee.object.pictureUrl, alt "", onClick (SelectionChanged (Model.Employee employee)) ] []


renderGuest : Model.Selectable Model.GuestInfo -> Html Msg
renderGuest guest =
    img [ src "./assets/guest.png", alt "" ] []


view : Model -> Html Msg
view model =
    div []
        [ errorMessage model.error
        , ul [] (List.map renderPlayer model.players)
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
