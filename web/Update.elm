module Update exposing (..)

import Config
import Dict exposing (Dict)
import Http
import Json.Decode as Json
import Material
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

        Mdl msg_ ->
            Material.update Mdl msg_ model


filterRelevant : List Model.EmployeeInfo -> List Model.EmployeeInfo
filterRelevant employees =
    List.filter (\e -> not (List.member { firstName = e.firstName, lastName = e.lastName } Config.excludedPlayers)) employees


refreshPlayers : Model -> List Model.EmployeeInfo -> Model
refreshPlayers model employees =
    let
        emps : List (Model.Selectable Model.Player)
        emps =
            List.map
                (\e -> { selected = False, object = Model.Employee e })
                (filterRelevant employees)

        guests : List (Model.Selectable Model.Player)
        guests =
            List.map
                (\g -> { selected = False, object = Model.Guest (Model.GuestInfo g) })
                (List.range 1 Config.numberOfGuests)

        players : Dict String (Model.Selectable Model.Player)
        players =
            Dict.fromList
                (emps
                    ++ guests
                    |> List.map (\p -> ( Model.playerId p.object, p ))
                )
    in
    { model | players = players, error = Nothing }


togglePlayerSelection : Dict String (Model.Selectable Model.Player) -> Model.Player -> Dict String (Model.Selectable Model.Player)
togglePlayerSelection players player =
    Dict.update (Model.playerId player) (Maybe.map (\p -> { p | selected = True })) players



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
