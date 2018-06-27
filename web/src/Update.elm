module Update exposing (..)

import Config
import Dict exposing (Dict)
import Http
import Json.Decode
import Json.Encode
import Message exposing (Msg(..))
import Model exposing (Model)
import Model.Getters as Get
import Model.Types exposing (..)
import Random
import Random.List
import Speech
import Storage


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Randomize ->
            ( model, randomize model )

        ClearLineUp ->
            ( { model | lineUp = Nothing }, Cmd.none )

        CreateLineUp players ->
            createLineUp model players

        LoadEmployeeInfoFromStorage ->
            ( model, tryLoadEmployeeInfoFromStorage )

        EmployeeInfoLoaded result ->
            case result of
                Ok result ->
                    ( refreshPlayers model result, refreshEmployeeInfoFromServer )
                Err message ->
                    ( { model | error = Just (Error message) }, refreshEmployeeInfoFromServer )

        LoadEmployeeInfoFromServer ->
            (model, refreshEmployeeInfoFromServer)

        EmployeeInfoRefreshed result ->
            case result of
                Ok result ->
                    ( refreshPlayers model result, updateEmployeeInfo result )

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

        storagePlayers : List Player
        storagePlayers = List.map (\e -> e.object) (Dict.values model.players)
        newEmps: List Player
        newEmps = List.filter (\e -> not(List.member e storagePlayers )) emps

        guests : List Player
        guests =
            List.map
                (\g -> Guest { number = g })
                (List.range 1 Config.numberOfGuests)

        newPlayers : Dict String (Selectable Player)
        newPlayers =
            Dict.fromList
                ((newEmps ++ guests)
                    |> List.sortWith (\a b -> Get.comparePlayers a b)
                    |> List.map (\p -> { selected = False, object = p })
                    |> List.map (\p -> ( Get.identifier p.object, p ))
                )
        
        players : Dict String (Selectable Player)
        players = Dict.union newPlayers model.players
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
    ( { model | loading = True }, tryLoadEmployeeInfoFromStorage )


refreshEmployeeInfoFromServer : Cmd Msg
refreshEmployeeInfoFromServer =
    Http.send EmployeeInfoRefreshed (Http.get Config.scrapingLink employeeDecoder)

updateEmployeeInfo : (List EmployeeInfo) -> Cmd Msg
updateEmployeeInfo employeeInfo =
    Storage.storeObject ("employeeInfo", employeeInfo |> encodeEmployees)

employeesInfoLoaded : Sub Msg
employeesInfoLoaded =
  let
    retrieval (key, json) =
      EmployeeInfoLoaded (Json.Decode.decodeValue employeeDecoder json)
  in
    Storage.objectRetrieved retrieval

tryLoadEmployeeInfoFromStorage : Cmd msg
tryLoadEmployeeInfoFromStorage = Storage.retrieveObject "employeeInfo"


employeeDecoder : Json.Decode.Decoder (List EmployeeInfo)
employeeDecoder =
    Json.Decode.list
        (Json.Decode.map3 EmployeeInfo
            (Json.Decode.at [ "firstName" ] Json.Decode.string)
            (Json.Decode.at [ "lastName" ] Json.Decode.string)
            (Json.Decode.at [ "pictureUrl" ] Json.Decode.string)
        )


encodeEmployees : List EmployeeInfo -> Json.Encode.Value
encodeEmployees employees =
    Json.Encode.list
        (employees
            |> List.map
                (\e ->
                    Json.Encode.object
                        [ ( "firstName", Json.Encode.string e.firstName )
                        , ( "lastName", Json.Encode.string e.lastName )
                        , ( "pictureUrl", Json.Encode.string e.pictureUrl )
                        ]
                )
        )
