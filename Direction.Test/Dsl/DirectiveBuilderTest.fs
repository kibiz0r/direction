namespace Direction.Test.Dsl

open System
open NUnit.Framework
open FsUnit
open Direction.Dsl
open Divination

type Car () =
    member val Opened = false with get, set

    member this.OpenDoor () =
        directive {
            return true
        }

module Ops =
    let create (ctor : 'T -> 'U) (args : 'T) =
        directive { return (ctor args) }

    //let alter ([<ReflectedDefinition>] alteration : Expr<unit>) =
    //    directive { return () }

open Ops

[<TestFixture; Ignore ("")>]
module DirectiveBuilderTest =
    [<Test>]
    let ``the dogs out`` () =
        true |> should be True
        ////let newCar = directive { return Car () }
        //let myDirective =
        //    directive {
        //        let! myCar = create Car ()
        //        //let! opened = myCar.OpenDoor ()
        //        alter (myCar.Opened <- true)
        //        let opened = myCar.Opened
        //        if opened then
        //            return 1
        //        else
        //            return 0
        //    }
        //myDirective |> should be instanceOfType<Directive<int>>
        //myDirective.Value |> should equal 1