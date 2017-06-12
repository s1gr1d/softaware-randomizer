module Model exposing (..)

import Dict exposing (Dict)
import Http
import Material


type alias EmployeeInfo =
    { firstName : String
    , lastName : String
    , pictureUrl : String
    }


type alias GuestInfo =
    { number : Int }



-- type alias Selectable a = { a | selected : Bool }


type alias Selectable a =
    { object : a, selected : Bool }


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


playerId : Player -> String
playerId player =
    case player of
        Employee employee ->
            employee.firstName ++ "." ++ employee.lastName

        Guest guest ->
            "Guest." ++ toString guest.number


displayName : Player -> String
displayName player =
    case player of
        Employee employee ->
            employee.firstName

        Guest guest ->
            "Gast " ++ toString guest.number


toggleSelection : Selectable Player -> Selectable Player
toggleSelection selectable =
    { selectable | selected = not selectable.selected }


selectedPlayers : Model -> List Player
selectedPlayers model =
    model.players
        |> Dict.values
        |> List.filter .selected
        |> List.map .object


isRandomizable : Model -> Bool
isRandomizable model =
    (model |> selectedPlayers |> List.length) >= 2


orderedPlayers : Model -> List (Selectable Player)
orderedPlayers model =
    model.players
        |> Dict.values
        |> List.sortWith (\a b -> playerOrder a.object b.object)


playerOrder : Player -> Player -> Order
playerOrder a b =
    case a of
        Employee ae ->
            case b of
                Employee be ->
                    compare ae.lastName be.lastName

                Guest bg ->
                    LT

        Guest ag ->
            case b of
                Employee be ->
                    GT

                Guest bg ->
                    compare ag.number bg.number


type alias Model =
    { players : Dict String (Selectable Player)
    , lineUp : Maybe LineUp
    , error : Maybe Error
    , loading : Bool
    , mdl : Material.Model
    }


defaultModel : Model
defaultModel =
    { players = Dict.empty
    , lineUp = Nothing
    , error = Nothing
    , loading = False
    , mdl = Material.model
    }


type Error
    = HttpError Http.Error
