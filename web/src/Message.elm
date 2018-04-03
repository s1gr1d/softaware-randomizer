module Message exposing (..)

import Http
import Model.Types exposing (EmployeeInfo, Player)


type Msg
    = Randomize
    | CreateLineUp (List Player)
    | ClearLineUp
    | SelectionChanged Player
    | LoadEmployeeInfoFromStorage
    | LoadEmployeeInfoFromServer
    | EmployeeInfoLoaded (Result String (List EmployeeInfo))
    | EmployeeInfoRefreshed (Result Http.Error (List EmployeeInfo))
