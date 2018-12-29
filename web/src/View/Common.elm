module View.Common exposing (..)

import Css
import Html
import Html.Attributes


styles : List Css.Mixin -> Html.Attribute msg
styles =
    Css.asPairs >> Html.Attributes.style
