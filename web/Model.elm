module Model exposing (..)

import Http


type alias EmployeeInfo =
    { firstName : String
    , lastName : String
    , pictureUrl : String
    }


type alias GuestInfo =
    { number : Int }


type alias Selectable a =
    { object : a, selected : Bool }


type alias LineUp =
    { teamAPlayer1 : Player
    , teamAPlayer2 : Player
    , teamBPlayer1 : Player
    , teamBPlayer2 : Player
    }


type Player
    = Employee (Selectable EmployeeInfo)
    | Guest (Selectable GuestInfo)


type alias Model =
    { players : List Player
    , result : Maybe LineUp
    , error : Maybe Error
    , loading : Bool
    }


type Error
    = HttpError Http.Error
