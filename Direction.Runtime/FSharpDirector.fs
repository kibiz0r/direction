namespace Direction.Runtime

open System
open System.Reflection
open FSharp.Quotations
open FSharp.Quotations.Patterns
open Direction.Core
open Divination

module FSharpIdentity =
    let rec expr (expr' : Expr) : Identity =
        match expr' with
        | NewObject (ctorInfo, argumentExprs) ->
            let argumentIdentities = List.map expr argumentExprs
            ConstructorIdentity (ctorInfo, argumentIdentities)
        | Call (thisExpr, methodInfo, argumentExprs) ->
            let thisIdentity =
                match thisExpr with
                | Some t -> Some (expr t)
                | None -> None
            let argumentIdentities = List.map expr argumentExprs
            CallIdentity (thisIdentity, methodInfo, argumentIdentities)
        | PropertyGet (thisExpr, propertyInfo, argumentExprs) ->
            let thisIdentity =
                match thisExpr with
                | Some t -> Some (expr t)
                | None -> None
            let argumentIdentities = List.map expr argumentExprs
            PropertyGetIdentity (thisIdentity, propertyInfo, argumentIdentities)
        | _ -> expr'.ToString () |> invalidArg "expr'"

type FSharpDirector () =
    let newChangeId () = ChangeId.random ()

    member this.ChangeResult<'T> (timeframe : Timeframe, changeDefinition : ChangeDefinition) : ChangeResult =
        try
            let value, effects =
                match changeDefinition.Identity with
                | ConstructorIdentity (:? ConstructorInfo as constructorInfo, arguments) ->
                    let arguments' =
                        arguments
                        |> List.map (fun a -> a :> obj) // divine these
                        |> List.toArray
                    let value = constructorInfo.Invoke (arguments') :?> 'T
                    value, []
                | CallIdentity (this', (:? MethodInfo as methodInfo), arguments) ->
                    let this'' = this' // divine this
                    let arguments' =
                        arguments
                        |> List.map (fun a -> a :> obj) // divine these
                        |> List.toArray
                    if methodInfo.ReturnType = typeof<Enactment<'T>> then
                        let enactment = methodInfo.Invoke (this'', arguments') :?> Enactment<'T>
                        let parameters : Map<string, Identity> = Map.empty // something like this
                        enactment.Evaluate ()
                    else
                        let value = methodInfo.Invoke (this'', arguments') :?> 'T
                        value, []
                | _ -> invalidArg "changeDefinition" ""
            ChangeSuccess (value, effects)
        with | e -> ChangeFailure e

    interface IDirector with
        member this.Timeframe (changeExpr : Expr) : Timeframe =
            Timeframe.empty

        member this.ChangeDefinition (changeExpr : Expr) : ChangeId * ChangeDefinition =
            let changeId = newChangeId ()
            let changeDefinition = { Identity = FSharpIdentity.expr changeExpr }
            changeId, changeDefinition

        member this.Change<'T> (timeframe : Timeframe, changeId : ChangeId, changeDefinition : ChangeDefinition) : Change<'T> =
            let changeResult = this.ChangeResult<'T> (timeframe, changeDefinition)
            let newTimeframe = Timeframe.change changeId changeDefinition changeResult timeframe
            let timeline = { HeadId = changeId; Timeframe = newTimeframe }
            Change<'T> (timeline)