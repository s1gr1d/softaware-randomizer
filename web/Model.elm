module Model exposing (..)

import Dict exposing (Dict)
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


playerId : Player -> String
playerId player =
    case player of
        Employee employee ->
            employee.object.firstName ++ "." ++ employee.object.lastName

        Guest guest ->
            "Guest." ++ toString guest.object.number


toggleSelection : Player -> Player
toggleSelection player =
    case player of
        Employee emp ->
            Employee { emp | selected = not emp.selected }

        Guest guest ->
            Guest { guest | selected = not guest.selected }


type alias Model =
    { players : Dict String Player
    , result : Maybe LineUp
    , error : Maybe Error
    , loading : Bool
    }


type Error
    = HttpError Http.Error
