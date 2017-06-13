module Message exposing (..)

import Http
import Model.Types exposing (EmployeeInfo, Player)


type Msg
    = Randomize
    | CreateLineUp (List Player)
    | ClearLineUp
    | SelectionChanged Player
    | LoadEmployees
    | EmployeeInfosLoaded (Result Http.Error (List EmployeeInfo))
