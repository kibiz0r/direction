namespace Direction.Test

open System
open Direction
open NUnit.Framework
open FsUnit

[<TestFixture>]
module TimelineBuilderTest =
    type CarDoorStatus =
        | CarDoorClosed
        | CarDoorOpened

    type Car () =
        let mutable doorStatus = CarDoorClosed
        let mutable currentGear = 1

        member this.DoorOpened () : Delta =
            delta {
                alter (doorStatus <- CarDoorOpened)
            }

        member this.OpenDoor () : Directive<CarDoorStatus> =
            directive {
                do! this.DoorOpened ()
                return CarDoorOpened
            }

        member this.ShiftInto (gear : int) : Directive<bool> =
            directive {
                return true
            }

    [<Test>]
    let ``Playground`` () =
        let myTimeline =
            timeline {
                let car = Car ()
                let! opened = car.OpenDoor ()
                return opened
            }
        true |> should be True

