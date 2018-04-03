port module Storage exposing (..)

import Json.Decode
import Json.Encode

port storeObject : (String, Json.Encode.Value) -> Cmd msg

port retrieveObject : String -> Cmd msg
port objectRetrieved : ((String, Json.Decode.Value) -> msg) -> Sub msg