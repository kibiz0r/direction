namespace Direction.Test

open System
open Direction
open NUnit.Framework
open FsUnit
open System.Reflection

[<TestFixture>]
module TimelineBuilderTest =
    type CarDoorStatus =
        | CarDoorClosed
        | CarDoorOpened

    type Car () =
        let mutable doorStatus = CarDoorClosed
        let mutable currentGear = 1

        member this.DoorStatus = doorStatus

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
                let! car = create Car ()
                let! openDoor = enact car.OpenDoor ()
                //let logDoorStatus = enact car.LogDoorStatus
                //do! openDoor >=> logDoorStatus
                let e = enact car.ShiftInto 3
                do! e
            }
        let car = myTimeline.GetDirected<Car> "car"
        car.Value.DoorStatus |> should equal CarDoorOpened

    // Prototype should be same as data in DirectiveDefinition, I think... just the return type that's new here.
    let directiveInvocationSignature (this : Directed<obj option>, methodInfo : Directed<MethodInfo>, arguments : Directed<obj list>) : Directed<Directive<obj>> =
        Directed<Directive<obj>> (Timeline (), "")