module Model.Types exposing (..)

import Http


type alias Selectable a =
    { object : a, selected : Bool }


type alias EmployeeInfo =
    { firstName : String
    , lastName : String
    , pictureUrl : String
    }


type alias GuestInfo =
    { number : Int }


type alias DoubleType =
    { teamA :
        { player1 : Player
        , player2 : Player
        }
    , teamB :
        { player1 : Player
        , player2 : Player
        }
    }


type alias SingleType =
    { player1 : Player
    , player2 : Player
    }


type LineUp
    = Single SingleType
    | Double DoubleType


type Player
    = Employee EmployeeInfo
    | Guest GuestInfo


type Error
    = HttpError Http.Error
    | Error String
