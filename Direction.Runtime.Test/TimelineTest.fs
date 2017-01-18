namespace Direction.Runtime.Test

open System
open System.Reflection
open NUnit.Framework
open FsUnit
open Direction.Runtime
open Direction.Core
open Divination

[<TestFixture>]
module TimelineTest =
    type CarRecord = {
        X : int
    }

    type Car =
        static member Create () =
            { CarRecord.X = 5 }

    [<Test>]
    let ``Timeline does stuff`` () =
        let history = History.empty
        let diviner = TimelineDiviner ()
        let timeline = Timeline (history, diviner)
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
        let result = timeline.Revise (changeId, change)
        let changeState = ChangeRevisionState (ChangeRevisionValueState (Car.Create ()))
        result |> should equal changeState