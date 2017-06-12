module Message exposing (..)

import Http
import Material
import Model


type Msg
    = Randomize
    | SelectionChanged Model.Player
    | EmployeeInfosLoaded (Result Http.Error (List Model.EmployeeInfo))
    | Mdl (Material.Msg Msg)
