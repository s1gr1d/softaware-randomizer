module Main exposing (..)

import Array exposing (Array, fromList, get)
import Html exposing (Attribute, Html, button, div, img, li, option, select, text, ul)
import Html.Attributes exposing (selected, size, src)
import Html.Events exposing (on, onClick)
import Http
import Json.Decode as Json
import List exposing (drop, head, map)
import Maybe exposing (withDefault)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Employee =
    { firstName : String
    , lastName : String
    , pictureUrl : String
    }


type alias Model =
    { employees : List Employee
    , error : FetchError
    }


type FetchError
    = None
    | Error Http.Error


init : ( Model, Cmd Msg )
init =
    ( Model [] None, loadEmployees )



-- UPDATE


type Msg
    = Load
    | EmployeesLoaded (Result Http.Error (List Employee))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Load ->
            ( model, loadEmployees )

        EmployeesLoaded result ->
            case result of
                Ok result ->
                    ( { model | employees = result, error = None }, Cmd.none )

                Err error ->
                    ( { model | error = Error error }, Cmd.none )


loadEmployees : Cmd Msg
loadEmployees =
    let
        url =
            "https://softaware-randomizer-api.azurewebsites.net/api/scrape?code=yBwvvbq/TaZO8wj0TUvnMjdaZTUKq64oSe14qaK0QL8IicRLLdDZLw=="
    in
    Http.send EmployeesLoaded (Http.get url decodeJson)


decodeJson : Json.Decoder (List Employee)
decodeJson =
    Json.list
        (Json.map3 Employee
            (Json.at [ "firstName" ] Json.string)
            (Json.at [ "lastName" ] Json.string)
            (Json.at [ "pictureUrl" ] Json.string)
        )



-- VIEW


renderEmployee : Employee -> Html Msg
renderEmployee employee =
    li [] [ img [ src employee.pictureUrl ] [] ]


renderEmployees : List Employee -> Html Msg
renderEmployees employees =
    let
        channelItems =
            List.map renderEmployee employees
    in
    ul [] channelItems


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Load ] [ text "Load Employees!" ]
        , errorMessage model.error
        , renderEmployees model.employees
        ]


errorMessage : FetchError -> Html Msg
errorMessage error =
    case error of
        None ->
            div [] []

        _ ->
            div []
                [ text (toString error)
                ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
