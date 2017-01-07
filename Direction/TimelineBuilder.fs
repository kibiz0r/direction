namespace Direction

open System
open System.Reflection
open FSharp.Quotations
open FSharp.Quotations.Evaluator
open FSharp.Quotations.Patterns
open Divination

type TimelineBuilder (history : History) =
    let mutable history = history

    member this.Bind ([<ReflectedDefinition>] directableExpr : Expr<IDirectable<'T>>, body : 'T -> unit) : unit =
        printfn "%A" directableExpr
        let pipeRight =
            match <@ 0 |> ignore @> with
            | Call (None, methodInfo, _) -> methodInfo
            | _ -> invalidOp ""
        let directableIgnore = <@ Directable.ignore @>
        let rec extractChangeExprAndArguments (expr : Expr) : MemberInfo * Expr list =
            match expr with
            | Call (None, pipeRight, e :: directableIgnore :: []) ->
                extractChangeExprAndArguments e
            | Call (None, methodInfo, arguments) ->
                methodInfo :> MemberInfo, arguments
            | PropertyGet (None, propertyInfo, indexerArguments) ->
                propertyInfo :> MemberInfo, indexerArguments
            | _ -> invalidOp ""
        let changeDefinition, changeArguments = extractChangeExprAndArguments directableExpr
        let change = { Change.Definition = changeDefinition; Arguments = changeArguments }
        history <- { history with Changes = List.append history.Changes [change] }
        printfn "%A" history
        body Unchecked.defaultof<'T>
        //let change = { Change.Expr = directableExpr }
        //{ Timeline.History = { History.Changes = [change] } }
        //Directable.expr directableExpr
        //|> Directable.unwrap
        //|> Directable.bind body

    member this.Zero () : unit =
        ()
        //{ Timeline.History = history }

    member this.Run _ : Timeline =
        { Timeline.History = history }