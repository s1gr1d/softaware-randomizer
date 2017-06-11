module Model exposing (..)

import Http


type alias Employee =
    { firstName : String
    , lastName : String
    , pictureUrl : String
    }


type alias Model =
    { employees : List Employee
    , error : FetchError
    }


type FetchError
    = None
    | Error Http.Error
