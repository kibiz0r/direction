namespace Direction.Test

open System
open Direction
open NUnit.Framework
open FsUnit
open System.Reflection
open FSharp.Quotations

[<TestFixture>]
module TimelineBuilderTest =
    let x = 5
    //type CarDoorStatus =
    //    | CarDoorClosed
    //    | CarDoorOpened

    //type Car () =
    //    let mutable doorStatus = CarDoorClosed
    //    let mutable currentGear = 1

    //    member this.DoorStatus = doorStatus

    //    member this.DoorOpened () : DeltaBody =
    //        delta {
    //            doorStatus <- CarDoorOpened
    //        }

    //    member this.DoorOpenedD () : Delta =
    //        Delta ()

    //    member this.OpenDoor () : DirectiveBody<CarDoorStatus> =
    //        directive {
    //            do! alter this.DoorOpened ()
    //            //do! this.DoorOpenedD ()
    //            return CarDoorOpened
    //        }

    //    member this.LogDoorStatus (status : CarDoorStatus) =
    //        directive {
    //            return ()
    //        }

    //    member this.ShiftUp () : DirectiveBody<unit> =
    //        directive {
    //            return ()
    //        }

    //    member this.ShiftDown () : DirectiveBody<unit> =
    //        directive {
    //            return ()
    //        }

    //    member this.ShiftInto (gear : int) : DirectiveBody<unit> =
    //        directive {
    //            if currentGear > gear then
    //                while currentGear > gear do
    //                    do! enact this.ShiftDown ()
    //            elif currentGear < gear then
    //                while currentGear < gear do
    //                    do! enact this.ShiftUp ()
    //        }

    //type Timeframe2 () =
    //    static member Current = Timeframe2 ()

    //type Directed2<'T> (timeframe : Timeframe2, guid : Guid, expr : Expr) =
    //    member this.Guid = guid
    //    member this.Expr = expr
    //    member this.Value = Unchecked.defaultof<'T>

    //type DirectiveDefinition2<'T, 'U> (f : 'T -> DirectiveBody<'U>) =
    //    class
    //    end

    //type Directive2<'T> () =
    //    member this.Guid = Guid ()
    //    member this.ReturnValue = Unchecked.defaultof<'T>

    //    member this.Commit () =
    //        ()

    //    static member Enact (definition : DirectiveDefinition2<'T, 'U>, argument : 'T) =
    //        Directive2<'U> ()

    //    static member Create<'T> ([<ParamArray>] arguments : obj []) =
    //        Directive2<'T> ()

    //[<Test>]
    //let ``Playground`` () =
    //    let myTimeline =
    //        timeline {
    //            let! car = create Car ()
    //            let! openDoor = enact car.OpenDoor ()
    //            //let logDoorStatus = enact car.LogDoorStatus
    //            //do! openDoor >=> logDoorStatus
    //            let e = enact car.ShiftInto 3
    //            do! e
    //        }
    //    let myTimeline' =
    //        <@
    //            let _timeframe = Timeframe2.Current
    //            let _Directed_Directive_Car_create_123 = Directed2<Directive2<Car>> (_timeframe, Guid.Empty, <@ Directive2.Create<Car> () @>)
    //            let _Directed_Car_car = Directed2<Car> (_timeframe, _Directed_Directive_Car_create_123.Value.Guid, <@ _Directed_Directive_Car_create_123.Value.ReturnValue @>)
    //            let _Directed_Directive_CarDoorStatus_openDoor_123 = Directed2<Directive<CarDoorStatus>> (_timeframe, _Directed_Directive_Car_create_123.Value.Guid, <@ Directive2.Enact (DirectiveDefinition2<unit, CarDoorStatus> (_Directed_Car_car.Value.OpenDoor), ()) @>)
    //            let _Directed_CarDoorStatus_openDoor = Directed2<CarDoorStatus> (_timeframe, _Directed_Directive_CarDoorStatus_openDoor_123.Value.Guid, <@ _Directed_Directive_CarDoorStatus_openDoor_123.Value.ReturnValue @>)
    //            let _Directed_Directive_unit_e = Directed2<Directive<unit>> (_timeframe, _Directed_Directive_CarDoorStatus_openDoor_123.Value.Guid, <@ Directive2.Enact (DirectiveDefinition2<int, unit> (_Directed_Car_car.Value.ShiftInto), 3) @>)
    //            do _Directed_Directive_unit_e.Value.Commit ()
    //        @>
    //    let car = myTimeline.GetDirected<Car> "car"
    //    car.Value.DoorStatus |> should equal CarDoorOpened

    //// Prototype should be same as data in DirectiveDefinition, I think... just the return type that's new here.
    //let directiveInvocationSignature (this : Directed<obj option>, methodInfo : Directed<MethodInfo>, arguments : Directed<obj list>) : Directed<Directive<obj>> =
    //    Directed<Directive<obj>> (Timeline (), "")