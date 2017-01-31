namespace Direction.Runtime.Test

open System
open System.Reflection
open NUnit.Framework
open FsUnit
open Direction.Runtime
open Direction.Core
open Divination

[<TestFixture>]
module FSharpDirectorTest =
    let director = FSharpDirector () :> IDirector

    type CarDoorStatus =
        | CarDoorOpened

    type Car () =
        member this.OpenDoor () =
            CarDoorOpened

    [<Test>]
    let ``defines creation of a car`` () =
        let changeId, changeDefinition = director.ChangeDefinition (<@ Car () @>)
        let expectedChangeDefinition = { ChangeDefinition.Identity = ConstructorIdentity (typeof<Car>.GetConstructor ([||]), []) }
        changeDefinition |> should equal expectedChangeDefinition

    [<Test>]
    let ``creates a car`` () =
        let directive = Directive.Enact (director, Car ())
        directive.Value |> should be instanceOfType<Car>

    [<Test>]
    let ``opens a car door`` () =
        let createCar = Directive.Enact (director, Car ())
        let openDoor = Directive.Enact (director, createCar.Value.OpenDoor ())
        openDoor.Value |> should equal CarDoorOpened