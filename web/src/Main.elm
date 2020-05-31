module Main exposing (..)

import Browser
import Message exposing (Msg)
import Model exposing (Model)
import Update exposing (init, update)
import View exposing (view)


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
