namespace Direction.Runtime.Test

open System
open System.Reflection
open NUnit.Framework
open FsUnit
open Direction.Runtime
open Direction.Core
open Divination

[<TestFixture>]
module TimelineStateTest =
    type CarRecord = {
        X : int
    }

    type Car =
        static member Create () =
            { CarRecord.X = 5 }

    [<Test>]
    let ``TimelineState does stuff`` () =
        let timelineState = { Head = RevisionId.empty; Timeframe = Timeframe.empty }
        let changeId = RevisionId.int 1
        let change =
            ChangeRevision {
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
        let changeState = ChangeRevisionState (ChangeRevisionValueState (Car.Create ()))
        let result = TimelineState.revise changeId change changeState timelineState
        result |> should equal
            {
                Head = changeId
                Timeframe =
                    {
                        RevisionGraphs = Map.ofList [(changeId, RevisionGraph.ofList [(changeId, change)])]
                        RevisionStates = Map.ofList [(change, changeState)]
                    }
            }