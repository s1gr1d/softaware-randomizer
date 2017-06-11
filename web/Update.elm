module Update exposing (..)

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
            ( { model | players = updatePlayer model.players player }, Cmd.none )


refreshPlayers : Model -> List Model.EmployeeInfo -> Model
refreshPlayers model employees =
    { model | players = List.map (\e -> Model.Employee (Model.Selectable e False)) employees, error = Nothing }


updatePlayer : List Model.Player -> Model.Player -> List Model.Player
updatePlayer players player =
    players



-- { model | players = List.map (\e -> Model.Employee (Model.Selectable e False)) employees, error = Nothing }


loadEmployees : Cmd Msg
loadEmployees =
    let
        url =
            "https://softaware-randomizer-api.azurewebsites.net/api/scrape?code=yBwvvbq/TaZO8wj0TUvnMjdaZTUKq64oSe14qaK0QL8IicRLLdDZLw=="
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
