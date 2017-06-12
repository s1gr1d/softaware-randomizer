module View exposing (..)

import Css
import Html exposing (Attribute, Html, button, div, img, li, option, p, select, text, ul)
import Html.Attributes exposing (alt, class, disabled, selected, size, src)
import Html.Events exposing (on, onClick)
import Material.Spinner as Loading
import Message exposing (Msg(ClearLineUp, Randomize, SelectionChanged))
import Model exposing (Model)


styles : List Css.Mixin -> Attribute msg
styles =
    Css.asPairs >> Html.Attributes.style


selectionOpacity : Model.Selectable Model.Player -> List Css.Mixin
selectionOpacity selectable =
    selectionToVisibility selectable.selected


selectionToVisibility : Bool -> List Css.Mixin
selectionToVisibility selected =
    [ Css.opacity
        (Css.num
            (if selected then
                1
             else
                0.47
            )
        )
    ]


renderPlayer : Model.Selectable Model.Player -> Html Msg
renderPlayer selectable =
    li [ styles ([ Css.width (Css.pct 23), Css.margin (Css.px 4), Css.position Css.relative ] ++ selectionOpacity selectable) ]
        [ case selectable.object of
            Model.Employee employee ->
                renderEmployee employee

            Model.Guest guest ->
                renderGuest guest
        ]


renderEmployee : Model.EmployeeInfo -> Html Msg
renderEmployee employee =
    img
        [ styles [ Css.maxWidth (Css.pct 100), Css.maxHeight (Css.pct 100) ]
        , src employee.pictureUrl
        , alt employee.firstName
        , onClick (SelectionChanged (Model.Employee employee))
        ]
        []


renderGuest : Model.GuestInfo -> Html Msg
renderGuest guest =
    img
        [ styles [ Css.maxWidth (Css.pct 100), Css.maxHeight (Css.pct 100) ]
        , src ("./assets/guest-" ++ toString guest.number ++ ".png")
        , alt ""
        , onClick (SelectionChanged (Model.Guest guest))
        ]
        []


white : Css.Color
white =
    Css.hex "ffffff"


pct100 : Css.Pct
pct100 =
    Css.pct 100


header : Html Msg
header =
    Html.header [ styles [ Css.backgroundColor white, Css.padding (Css.rem 1), Css.displayFlex, Css.justifyContent Css.center, Css.alignItems Css.center ] ]
        [ img [ styles [ Css.height (Css.rem 4) ], src "./assets/softaware-icon.png" ] []
        , Html.h1 [ styles [ Css.height (Css.rem 2), Css.margin2 Css.zero (Css.rem 0.2), Css.textTransform Css.uppercase, Css.fontSize (Css.rem 1.5), Css.fontFamily Css.sansSerif ] ] [ text "▷" ]
        , img [ styles [ Css.height (Css.rem 4) ], src "./assets/soccer.png" ] []
        ]


view : Model -> Html Msg
view model =
    div [ styles [ Css.boxSizing Css.borderBox, Css.backgroundImage (Css.url "./assets/background.jpg"), Css.backgroundPosition Css.top, Css.backgroundSize Css.cover, Css.height (Css.vh 100), Css.width (Css.vw 100) ] ]
        [ errorMessage model.error
        , header
        , div []
            [ Html.header
                [ styles [ Css.height (Css.rem 7) ] ]
                []
            ]
        , Loading.spinner
            [ Loading.active model.loading ]
        , lineUp model
        , ul [ styles [ Css.listStyleType Css.none, Css.margin Css.zero, Css.padding Css.zero, Css.displayFlex, Css.flexWrap Css.wrap, Css.justifyContent Css.center ] ]
            (List.map renderPlayer (Model.orderedPlayers model))
        , button
            [ disabled (Model.isRandomizable model), onClick Randomize ]
            [ text "Randomize" ]
        ]


lineUp : Model -> Html Msg
lineUp model =
    case model.lineUp of
        Nothing ->
            div [] []

        Just lineUp ->
            div [] []


errorMessage : Maybe Model.Error -> Html Msg
errorMessage error =
    case error of
        Nothing ->
            div [] []

        _ ->
            div []
                [ text (toString error) ]
