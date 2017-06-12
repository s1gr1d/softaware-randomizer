module Config exposing (..)

scrapingLink : String
scrapingLink =
    "https://softaware-randomizer-api.azurewebsites.net/api/scrape?code=yBwvvbq/TaZO8wj0TUvnMjdaZTUKq64oSe14qaK0QL8IicRLLdDZLw=="



-- Make sure that enough icons are available in /assets


numberOfGuests : Int
numberOfGuests =
    4


excludedPlayers : List { firstName : String, lastName : String }
excludedPlayers =
    [ { firstName = "Angela", lastName = "Hofer" }
    , { firstName = "Ritta", lastName = "Khamis" }
    , { firstName = "Gabriele", lastName = "Käferböck" }
    ]
