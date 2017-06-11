module Update exposing (..)

import Config
import Dict exposing (Dict)
import Http
import Json.Decode as Json
import Message exposing (Msg(..))
import Model exposing (Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Randomize ->
            ( model, Cmd.none )

        EmployeeInfosLoaded result ->
            case result of
                Ok result ->
                    ( refreshPlayers model result, Cmd.none )

                Err error ->
                    ( { model | error = Just (Model.HttpError error) }, Cmd.none )

        SelectionChanged player ->
            ( { model | players = togglePlayerSelection model.players player }, Cmd.none )


refreshPlayers : Model -> List Model.EmployeeInfo -> Model
refreshPlayers model employees =
    let
        players =
            Dict.fromList
                (List.append
                    (List.map
                        (\e -> Model.Employee (Model.Selectable e False))
                        employees
                    )
                    (List.map
                        (\g -> Model.Guest (Model.Selectable (Model.GuestInfo g) False))
                        (List.range 1 Config.numberOfGuests)
                    )
                    |> List.map (\p -> ( Model.playerId p, p ))
                )
    in
    { model | players = players, error = Nothing }


togglePlayerSelection : Dict String Model.Player -> Model.Player -> Dict String Model.Player
togglePlayerSelection players player =
    Dict.update (Model.playerId player) (Maybe.map Model.toggleSelection) players



-- { p | selected = not p.selected }


loadEmployees : Cmd Msg
loadEmployees =
    let
        url =
            Config.scrapingLink
    in
    Http.send EmployeeInfosLoaded (Http.get url decodeJson)


decodeJson : Json.Decoder (List Model.EmployeeInfo)
decodeJson =
    Json.list
        (Json.map3 Model.EmployeeInfo
            (Json.at [ "firstName" ] Json.string)
            (Json.at [ "lastName" ] Json.string)
            (Json.at [ "pictureUrl" ] Json.string)
        )
