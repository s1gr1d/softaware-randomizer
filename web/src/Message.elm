module Message exposing (..)

import Http
import Model


type Msg
    = Randomize
    | CreateLineUp (List Model.Player)
    | ClearLineUp
    | SelectionChanged Model.Player
    | LoadEmployees
    | EmployeeInfosLoaded (Result Http.Error (List Model.EmployeeInfo))
