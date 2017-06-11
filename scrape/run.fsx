#r "FSharp.Data"
#r "System.Net.Http"
#r "System.Runtime.Serialization"

open System.Net
open System.Net.Http
open System.Runtime.Serialization
// https://fsharp.github.io/FSharp.Data/library/HtmlProvider.html
open FSharp.Data

[<DataContract>]
[<StructuredFormatDisplay("{name} ({url})")>]
type Employee = {
    [<field: DataMember(Name="firstName")>]
    firstName: string
    [<field: DataMember(Name="lastName")>]
    lastName: string
    [<field: DataMember(Name="pictureUrl")>]
    pictureUrl: string
}

[<Literal>]
let TEAM_URL = "https://www.softaware.at/about-us/team.html"

let Run(req: HttpRequestMessage, log: TraceWriter) =
    async {
        log.Info(sprintf 
            "Scraping started...")
        
        // http://www.ojdevelops.com/2016/03/web-scraping-with-f.html
        let result = HtmlProvider<TEAM_URL, Encoding="UTF-8">.Load(TEAM_URL)

        let employees = 
            result.Html.Descendants()
            |> Seq.filter(fun n -> n.HasName "section" && n.HasClass "section")
            |> Seq.head
            |> fun n -> n.Descendants()
            |> Seq.filter(fun n -> n.HasName "img")
            |> Seq.map(fun n -> {
                                firstName=((n.Attribute "alt").Value().Split [|' '|]).[0];
                                lastName=((n.Attribute "alt").Value().Split [|' '|]).[1];
                                pictureUrl=Uri("https://www.softaware.at" + (n.Attribute "src").Value()).AbsoluteUri })

        // https://stackoverflow.com/questions/43118406/return-an-f-record-type-as-json-in-azure-functions?noredirect=1&lq=1
        return req.CreateResponse(HttpStatusCode.OK, employees);
    } |> Async.RunSynchronously
