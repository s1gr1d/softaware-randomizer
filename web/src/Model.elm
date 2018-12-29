module Model exposing (..)

import Dict exposing (Dict)
import Model.Types exposing (..)


type alias Model =
    { players : Dict String (Selectable Player)
    , lineUp : Maybe LineUp
    , error : Maybe Error
    , loading : Bool
    }


defaultModel : Model
defaultModel =
    { players = Dict.empty
    , lineUp = Nothing
    , error = Nothing
    , loading = False
    }
