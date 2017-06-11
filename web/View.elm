module View exposing (..)

import Html exposing (Attribute, Html, button, div, img, li, option, select, text, ul)
import Html.Attributes exposing (selected, size, src)
import Html.Events exposing (on, onClick)
import Message exposing (Msg(..))
import Model exposing (Model)


renderEmployee : Model.Employee -> Html Msg
renderEmployee employee =
    li [] [ img [ src employee.pictureUrl ] [] ]


renderEmployees : List Model.Employee -> Html Msg
renderEmployees employees =
    let
        channelItems =
            List.map renderEmployee employees
    in
    ul [] channelItems


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Load ] [ text "Load Employees!" ]
        , errorMessage model.error
        , renderEmployees model.employees
        ]


errorMessage : Model.FetchError -> Html Msg
errorMessage error =
    case error of
        Model.None ->
            div [] []

        _ ->
            div []
                [ text (toString error)
                ]
