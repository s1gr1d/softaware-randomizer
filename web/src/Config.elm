module Config exposing (..)


assetPath : String
assetPath =
    "assets/"


scrapingLink : String
scrapingLink =
    "https://randomizer-api.azurewebsites.net/api/scrape?code=vI1f1U4GgDqg1guQArJj3aLx00VxA/l9EFJ43tUO2Dz3mIGINrnb4g=="


numberOfGuests : Int
numberOfGuests =
    4


excludedPlayers : List { firstName : String, lastName : String }
excludedPlayers =
    [ { firstName = "Angela", lastName = "Hofer" }
    , { firstName = "Ritta", lastName = "Khamis" }
    , { firstName = "Gabriele", lastName = "Käferböck" }
    ]
