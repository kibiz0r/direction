namespace Direction.Test.Data

open System
open System.IO
open NUnit.Framework
open FsUnit
open Direction.Data

[<TestFixture>]
module HistoryDataJsonSerializerTest =
    let serialize data =
        let fileName = Path.GetTempFileName ()
        let writer = File.CreateText fileName
        let serializer = HistoryDataJsonSerializer ()
        serializer.Serialize (writer, data)
        fileName

    let deserialize fileName : HistoryData =
        let reader = File.OpenText fileName
        let serializer = HistoryDataJsonSerializer ()
        serializer.Deserialize (reader)

    [<Test>]
    let ``HistoryData can be serialized to a JSON file`` () =
        let data : HistoryData =
            {
                Revisions = Map.empty
                Head = RevisionId.NewGuid ()
            }
        let fileName = serialize data
        File.Exists fileName |> should be True

    [<Test>]
    let ``HistoryData can be deserialized from a JSON file`` () =
        let data : HistoryData =
            {
                Revisions = Map.empty
                Head = RevisionId.NewGuid ()
            }
        let fileName = serialize data
        let data2 = deserialize fileName
        data2 |> should equal data