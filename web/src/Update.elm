module Update exposing (..)

import Config
import Dict exposing (Dict)
import Http
import Json.Decode as Json
import Message exposing (Msg(..))
import Model exposing (Model)
import Model.Getters as Get
import Model.Types exposing (..)
import Random
import Random.List
import Speech


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Randomize ->
            ( model, randomize model )

        ClearLineUp ->
            ( { model | lineUp = Nothing }, Cmd.none )

        CreateLineUp players ->
            createLineUp model players

        LoadEmployees ->
            ( model, loadEmployees )

        EmployeeInfosLoaded result ->
            case result of
                Ok result ->
                    ( refreshPlayers model result, Cmd.none )

                Err error ->
                    ( { model | error = Just (HttpError error) }, Cmd.none )

        SelectionChanged player ->
            ( { model | players = togglePlayerSelection model.players player }, Cmd.none )


randomize : Model -> Cmd Msg
randomize model =
    Random.generate (\players -> CreateLineUp players)
        (model |> Get.selectedPlayers |> Random.List.shuffle)


createLineUp : Model -> List Player -> ( Model, Cmd Msg )
createLineUp model players =
    let
        lineUp : Maybe LineUp
        lineUp =
            case players of
                [] ->
                    Nothing

                _ :: [] ->
                    Nothing

                a1 :: a2 :: [] ->
                    Just (Single { player1 = a1, player2 = a2 })

                a1 :: a2 :: _ :: [] ->
                    Just (Single { player1 = a1, player2 = a2 })

                a1 :: a2 :: b1 :: b2 :: _ ->
                    Just (Double { teamA = { player1 = a1, player2 = a2 }, teamB = { player1 = b1, player2 = b2 } })

        command : Cmd Msg
        command =
            case lineUp of
                Nothing ->
                    Cmd.none

                Just lineUp ->
                    Speech.speak (Get.moderation lineUp)
    in
    ( { model | lineUp = lineUp }, command )


refreshPlayers : Model -> List EmployeeInfo -> Model
refreshPlayers model employees =
    let
        relevantEmployees : List EmployeeInfo
        relevantEmployees =
            List.filter (\e -> not (List.member { firstName = e.firstName, lastName = e.lastName } Config.excludedPlayers)) employees

        emps : List Player
        emps =
            List.map
                (\e -> Employee e)
                relevantEmployees

        guests : List Player
        guests =
            List.map
                (\g -> Guest { number = g })
                (List.range 1 Config.numberOfGuests)

        players : Dict String (Selectable Player)
        players =
            Dict.fromList
                ((emps ++ guests)
                    |> List.sortWith (\a b -> Get.comparePlayers a b)
                    |> List.map (\p -> { selected = False, object = p })
                    |> List.map (\p -> ( Get.identifier p.object, p ))
                )
    in
    { model | players = players, error = Nothing, loading = False }


togglePlayerSelection : Dict String (Selectable Player) -> Player -> Dict String (Selectable Player)
togglePlayerSelection players player =
    Dict.update
        (Get.identifier player)
        (Maybe.map (\p -> { p | selected = not p.selected }))
        players


init : ( Model, Cmd Msg )
init =
    let
        model =
            Model.defaultModel
    in
    ( { model | loading = True }, loadEmployees )


loadEmployees : Cmd Msg
loadEmployees =
    Http.send EmployeeInfosLoaded (Http.get Config.scrapingLink decodeJson)


decodeJson : Json.Decoder (List EmployeeInfo)
decodeJson =
    Json.list
        (Json.map3 EmployeeInfo
            (Json.at [ "firstName" ] Json.string)
            (Json.at [ "lastName" ] Json.string)
            (Json.at [ "pictureUrl" ] Json.string)
        )
