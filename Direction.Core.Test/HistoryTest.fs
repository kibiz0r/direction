namespace Direction.Core.Test

open System
open NUnit.Framework
open FsUnit
open Direction.Core
open Divination

[<TestFixture>]
module HistoryTest =
    type Car () =
        static member Create () =
            Car ()

    [<Test>]
    let ``History does stuff`` () =
        let history = History.empty
        let changeId = ChangeId.int 1
        let change : ChangeDefinition =
            {
                Identity =
                    CallIdentity (
                        None,
                        {
                            DeclaringType = typeof<Car>.AssemblyQualifiedName
                            MethodName = "Create"
                        },
                        []
                    )
            }
        let changed = History.change changeId change history
        changed.Head |> should equal changeId

//namespace Direction.Test.Runtime

//open System
//open NUnit.Framework
//open FsUnit
//open Direction.Runtime
//open Direction.Data

//[<TestFixture>]
//module HistoryTest =
//    type Car () =
//        static member Create () : Car =
//            Car ()

//    [<Test>]
//    let ``History can be constructed from HistoryData`` () =
//        let data : HistoryData =
//            {
//                Revisions = Map.empty
//                Head = RevisionId.NewGuid ()
//            }
//        let history = History.FromData data
//        history |> should not' (be null)

//    [<Test>]
//    let ``History can create an object using a method`` () =
//        let history = History ()
//        let returnValue = history.Change (CallExpr (None, MethodInfoData.fromExpr <@ Car.Create () @>, []))
//        returnValue |> should be instanceOfType<Car>