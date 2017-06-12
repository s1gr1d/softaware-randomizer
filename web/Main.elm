module Main exposing (..)

import Dict exposing (Dict)
import Html
import Message exposing (Msg)
import Model exposing (Model)
import Update exposing (loadEmployees, update)
import View exposing (view)


init : ( Model, Cmd Msg )
init =
    ( Model.defaultModel, loadEmployees )


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
