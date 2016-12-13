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

        member this.DoorOpened () : DeltaBody =
            delta {
                doorStatus <- CarDoorOpened
            }

        member this.DoorOpenedD () : Delta =
            Delta ()

        member this.OpenDoor () : DirectiveBody<CarDoorStatus> =
            directive {
                do! alter this.DoorOpened ()
                //do! this.DoorOpenedD ()
                return CarDoorOpened
            }

        member this.LogDoorStatus (status : CarDoorStatus) =
            directive {
                return ()
            }

        member this.ShiftUp () : DirectiveBody<unit> =
            directive {
                return ()
            }

        member this.ShiftDown () : DirectiveBody<unit> =
            directive {
                return ()
            }

        member this.ShiftInto (gear : int) : DirectiveBody<unit> =
            directive {
                if currentGear > gear then
                    while currentGear > gear do
                        do! enact this.ShiftDown ()
                elif currentGear < gear then
                    while currentGear < gear do
                        do! enact this.ShiftUp ()
            }

    [<Test>]
    let ``Playground`` () =
        let myTimeline =
            timeline {
                let car = Car ()
                let! openDoor = enact car.OpenDoor ()
                //let logDoorStatus = enact car.LogDoorStatus
                //do! openDoor >=> logDoorStatus
                do! enact car.ShiftInto 3
            }
        true |> should be True

