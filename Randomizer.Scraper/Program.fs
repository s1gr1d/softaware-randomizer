// Learn more about F# at http://fsharp.org
// See the 'F# Tutorial' project for more help.

// https://fsharp.github.io/FSharp.Data/library/HtmlProvider.html
open FSharp.Data

[<StructuredFormatDisplay("{name} ({url})")>]
type Employee = {
    firstName: string
    lastName: string
    pictureUrl: string
}

// http://www.ojdevelops.com/2016/03/web-scraping-with-f.html
[<Literal>]
let TEAM_URL = "https://www.softaware.at/about-us/team.html"
let result = HtmlProvider<TEAM_URL, Encoding="UTF-8">.Load(TEAM_URL)

[<EntryPoint>]
let main argv = 
    result.Html.Descendants()
    |> Seq.filter(fun n -> n.HasName "section" && n.HasClass "section")
    |> Seq.head
    |> fun n -> n.Descendants()
    |> Seq.filter(fun n -> n.HasName "img")
    |> Seq.map(fun n -> { firstName=(n.Attribute "alt").Value(); lastName="TODO"; pictureUrl=(n.Attribute "src").Value() })
    |> Seq.iter (fun n -> printfn "%s %s (%s)" n.firstName n.lastName n.pictureUrl)
    0
