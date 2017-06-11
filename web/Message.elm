module Message exposing (..)

import Http
import Model


type Msg
    = Randomize
    | SelectionChanged Model.Player
    | EmployeeInfosLoaded (Result Http.Error (List Model.EmployeeInfo))
