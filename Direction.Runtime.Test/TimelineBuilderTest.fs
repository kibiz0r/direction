namespace Direction.Runtime.Test

open System
open NUnit.Framework
open FsUnit
open Direction.Runtime
open Direction.Core
open Divination

[<TestFixture>]
module TimelineBuilderTest =
    [<Test>]
    let ``does something`` () =
        let myTimeline : Timeline =
            timeline {
            }
        Assert.IsTrue true

