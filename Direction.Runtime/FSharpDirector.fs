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
    interface IDirector with
        member this.Id (changeDefinition : ChangeDefinition) =
            0 : ChangeId

        member this.Id (effectDefinition : EffectDefinition) =
            0 : EffectId

        member this.Evaluate (change : Change) : ChangeResult =
            ChangeSuccess (obj (), [])

        member this.Merge (timeframes : Set<Timeframe>) =
            Timeframe.empty

    member this.Define (expr : Expr<Enactment<'T>>) : ChangeDefinition =
        { Identity = Identifier 0 }