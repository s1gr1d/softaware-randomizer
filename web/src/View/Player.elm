module View.Player exposing (..)

import Css exposing (..)
import Html.Styled exposing (Attribute, Html, img)
import Html.Styled.Attributes exposing (alt, css, src)
import Html.Styled.Events exposing (onClick)
import Message exposing (Msg(..))
import Model.Getters as Get
import Model.Types exposing (..)



-- HELPERS --


renderPlayer : Player -> List Style -> List (Attribute Msg) -> Html Msg
renderPlayer player style attributes =
    img
        ([ css (style ++ [ property "object-fit" "contain" ])
         , src (player |> Get.pictureUrl)
         , alt (player |> Get.displayName)
         ]
            ++ attributes
        )
        []


toOpacity : Selectable Player -> Style
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


renderPlayerRounded : Player -> List Style -> Html Msg
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
            5

        player =
            selectable.object
    in
    renderPlayer
        player
        [ property "width" ("calc(" ++ String.fromInt (100 // playerColumns) ++ "% - " ++ String.fromInt (2 * playerPadding) ++ "px)")
        , margin (px playerPadding)
        , position relative
        , selectable |> toOpacity
        ]
        [ onClick (SelectionChanged player) ]
