module Model.Getters exposing (..)

import Config
import Dict
import Model exposing (Model)
import Model.Types exposing (..)



-- HELPERS


map : Player -> (EmployeeInfo -> a) -> (GuestInfo -> a) -> a
map player fromEmployee fromGuest =
    case player of
        Employee employee ->
            fromEmployee employee

        Guest guest ->
            fromGuest guest



----------


identifier : Player -> String
identifier player =
    map player
        (\e -> e.lastName ++ "." ++ e.firstName)
        (\g -> "guest." ++ String.fromInt g.number)


displayName : Player -> String
displayName player =
    map player
        (\e -> e.firstName)
        (\g -> "Gast " ++ String.fromInt g.number)


pictureUrl : Player -> String
pictureUrl player =
    map player
        (\e -> e.pictureUrl)
        (\g -> Config.assetPath ++ "guest/" ++ String.fromInt g.number ++ ".png")


selectedPlayers : Model -> List Player
selectedPlayers model =
    model.players
        |> Dict.values
        |> List.filter .selected
        |> List.map .object


isRandomizable : Model -> Bool
isRandomizable model =
    (model |> selectedPlayers |> List.length) >= 2


comparePlayers : Player -> Player -> Order
comparePlayers a b =
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
