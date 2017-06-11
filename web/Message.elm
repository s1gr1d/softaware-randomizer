module Message exposing (..)

import Http
import Model


type Msg
    = Load
    | EmployeesLoaded (Result Http.Error (List Model.Employee))
