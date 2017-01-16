namespace Direction.Data

open System
open System.IO
open MBrace.FsPickler.Json

type HistoryDataJsonSerializer () =
    let serializer = FsPickler.CreateJsonSerializer (indent = true)

    member this.Serialize (writer : TextWriter, historyData : HistoryData) =
        serializer.Serialize (writer, historyData)

    member this.Deserialize (reader : TextReader) : HistoryData =
        serializer.Deserialize (reader)