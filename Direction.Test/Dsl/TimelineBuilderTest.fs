namespace Direction.Test.Dsl

open System
open System.Reflection
open NUnit.Framework
open FsUnit
open Direction.Dsl
open Divination
open FSharp.Quotations
open FSharp.Quotations.Patterns

// Change is a serializable record representing the invocation of a command that triggered a state transition
// Effect is a serializable record representing the mutation of data that occurred as a result of a command-triggered state transition
// History is an immutable container for serialized Changes and Effects; it is, itself, serializable
// Timeline is an immutable container for materialized Changes and Effects within a single Timeframe; it has a backing History; it maps Changes and Effects to Timeframes
// Timeframe is an execution context for a single invocation of a Change or Effect; but it does not know what Change/Effect it is representing or its GUID; it has a Timeline
// Directive<'T> is a reference to an occurrence of a Change, which can be dereferenced within a given Timeframe; crucially, it has a GUID
// Delta is a reference to an occurrence of an Effect, which can be dereferenced within a given Timeframe; crucially, it has a GUID
// DirectiveBody<'T> is an execution context for a Directive<'T>, specifically; it can only be executed when given a Timeframe to read from, and it results in a single new Timeframe
// DirectiveDefinition<'T, 'U> is a reference to a method that accepts a 'T and returns a DirectiveBody<'U>; it can be dereferenced within a Timeframe
// DirectiveInvocation<'T> is a reference to an invocation of a DirectiveDefinition<_, 'T>; its definition and its arguments can be dereferenced within a Timeframe

type FooBuilder () =
    let mutable processedVars : Var list = []

    member this.Bind ([<ReflectedDefinition true>] valueExprWithValue : Expr<'T>, [<ReflectedDefinition true>] bodyExprWithValue : Expr<'T -> 'U>) : 'U =
        match valueExprWithValue with
        | WithValue (:? 'T as value, _, valueExpr) ->
            match bodyExprWithValue with
            | WithValue (:? ('T -> 'U) as body, _, bodyExpr) ->
                let processedVar =
                    match bodyExpr with
                    | Lambda (letVar, _) -> letVar
                    | _ -> invalidOp ""
                processedVars <- processedVar :: processedVars
                body value
            | _ -> invalidOp ""
        | _ -> invalidOp ""

    member this.Return ([<ReflectedDefinition true>] valueExprWithValue : Expr<'T>) : 'T =
        match valueExprWithValue with
        | WithValue (:? 'T as value, _, valueExpr) ->
            let processedVar =
                match valueExpr with
                | Patterns.Var (var) -> var
                | _ -> invalidOp ""
            if List.contains processedVar processedVars then
                printfn "Recognized var!"
            processedVars <- processedVar :: processedVars
            value
        | _ -> invalidOp ""

[<TestFixture; Ignore ("")>]
module TimelineBuilderTest =
    //let unitDirective = DirectiveDefinition<unit> ()
    //let intDirective = DirectiveDefinition<int> ()

    let intToBoolFunc (x : int) : DirectiveInvocation<bool> =
        directive { return x = 5 }

    let unitToUnitFunc () : DirectiveInvocation<unit> =
        directive { return () }

    //let callToGetIntDirective x =
    //    intDirective

    type Car () =
        member this.OpenDoor () =
            "Opened"

    [<Test>]
    let ``the dogs out`` () =
        let foo = FooBuilder ()
        let r =
            foo {
                let! x = Car ()
                return x
            }
        r |> should equal 6

        //let currentTimeframe = Timeframe.empty
        //let carCtor = match <@ Car () @>  with | Call (_, m, _) -> m | invalidOp ""
        //let createCar : Change = { This = None; Definition = carCtor; Arguments = [] }
        //let createdCarTimeframe = Timeframe.commit createCar currentTimeframe

        //let def : DirectiveDefinition<int, bool> ()
        //let someFunc (x : int) : DirectiveBody<bool> =
        //    DirectiveBody<bool> ()
        //let timeframe =
        //    timeframe {
        //        //let! d : Directive<bool> = (def.Invoke 5 : DirectiveInvocation<bool>)
        //        let! d : Directive<bool> = someFunc 5 // processed via ReflectedDefinition, turned into DirectiveInvocation<bool>
        //    }
        //let timeline =
        //    timeline { Changes = [] } {
        //        let! i = intToBoolFunc 5
        //        do! unitToUnitFunc ()
        //    }
        //true |> should be True
        //let memberInfo expr =
        //    match expr with
        //    | Call (_, m, _) -> m :> MemberInfo
        //    | PropertyGet (_, p, _) -> p :> MemberInfo
        //    | _ -> invalidOp ""
        //let intDirectiveInfo = memberInfo <@ intDirective @>
        //let callToGetIntDirectiveInfo = memberInfo <@ callToGetIntDirective 5 @>
        //let unitDirectiveInfo = memberInfo <@ unitDirective @>
        //let fiveExpr = <@ 5 @>
        //timeline.History.Changes |> should equal [
        //    { Change.Definition = intDirectiveInfo; Arguments = [] }
        //    { Change.Definition = intDirectiveInfo; Arguments = [] }
        //    { Change.Definition = callToGetIntDirectiveInfo; Arguments = [fiveExpr] }
        //    { Change.Definition = unitDirectiveInfo; Arguments = [] }
        //]