module Update exposing (..)

import Http
import Json.Decode as Json
import Message exposing (Msg(EmployeesLoaded, Load))
import Model exposing (Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Load ->
            ( model, loadEmployees )

        EmployeesLoaded result ->
            case result of
                Ok result ->
                    ( { model | employees = result, error = Model.None }, Cmd.none )

                Err error ->
                    ( { model | error = Model.Error error }, Cmd.none )


loadEmployees : Cmd Msg
loadEmployees =
    let
        url =
            "https://softaware-randomizer-api.azurewebsites.net/api/scrape?code=yBwvvbq/TaZO8wj0TUvnMjdaZTUKq64oSe14qaK0QL8IicRLLdDZLw=="
    in
    Http.send EmployeesLoaded (Http.get url decodeJson)


decodeJson : Json.Decoder (List Model.Employee)
decodeJson =
    Json.list
        (Json.map3 Model.Employee
            (Json.at [ "firstName" ] Json.string)
            (Json.at [ "lastName" ] Json.string)
            (Json.at [ "pictureUrl" ] Json.string)
        )
