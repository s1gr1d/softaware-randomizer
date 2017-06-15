module View.Player exposing (..)

import Css exposing (..)
import Html exposing (Html, img)
import Html.Attributes
import Html.Events
import Message exposing (Msg(SelectionChanged))
import Model.Getters as Get
import Model.Types exposing (..)
import View.Common exposing (styles)


-- HELPERS --


renderPlayer : Player -> List Mixin -> List (Html.Attribute Msg) -> Html Msg
renderPlayer player style attributes =
    img
        ([ styles (style ++ [ property "object-fit" "contain" ])
         , Html.Attributes.src (player |> Get.pictureUrl)
         , Html.Attributes.alt (player |> Get.displayName)
         ]
            ++ attributes
        )
        []


toOpacity : Selectable Player -> Mixin
toOpacity selectable =
    opacity
        (num
            (if selectable.selected then
                1
             else
                0.47
            )
        )



-------------


renderPlayerRounded : Player -> List Mixin -> Html Msg
renderPlayerRounded player style =
    renderPlayer player
        ([ width (pct 22)
         , borderRadius (pct 50)
         , boxShadow4 zero (px 5) (px 30) (rgba 0 0 0 0.2)
         ]
            ++ style
        )
        []


renderPlayerSelectable : Selectable Player -> Html Msg
renderPlayerSelectable selectable =
    let
        playerColumns =
            4

        playerPadding =
            2

        player =
            selectable.object
    in
    renderPlayer
        player
        [ property "width" ("calc(" ++ toString (100 // playerColumns) ++ "% - " ++ toString (2 * playerPadding) ++ "px)")
        , margin (px playerPadding)
        , position relative
        , selectable |> toOpacity
        ]
        [ Html.Events.onClick (SelectionChanged player) ]
