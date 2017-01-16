namespace Direction.Dsl

open System
open System.Reflection
open FSharp.Quotations
open FSharp.Quotations.Evaluator
open FSharp.Quotations.Patterns
open Divination
open Direction.Runtime

type TimelineBuilder (history : History) =
    let mutable history = history
    //let mutable timeline = Timeline (history)

    ////member this.Bind ([<ReflectedDefinition>] directiveDefinitionExpr : Expr<unit>, body : unit -> unit) : unit =
    ////    let directiveInvocation = Directive.Enact directiveDefinitionExpr
    ////    let directive = timeline.InvokeDirective directiveInvocation
    ////    directive |> body

    //member this.Bind ([<ReflectedDefinition>] directiveInvocationExpr : Expr<DirectiveInvocation<'T>>, body : 'T -> unit) : unit =
    //    //let directiveInvocation = Directive.Enact directiveDefinitionExpr
    //    let directiveInvocation = DirectiveInvocation<'T> ()
    //    let directive = timeline.InvokeDirective directiveInvocation
    //    let value = Unchecked.defaultof<'T>
    //    body value
    //    //printfn "%A" directableExpr
    //    //let pipeRight =
    //    //    match <@ 0 |> ignore @> with
    //    //    | Call (None, methodInfo, _) -> methodInfo
    //    //    | _ -> invalidOp ""
    //    //let directableIgnore = <@ Directable.ignore @>
    //    //let rec extractChangeExprAndArguments (expr : Expr) : MemberInfo * Expr list =
    //    //    match expr with
    //    //    | Call (None, pipeRight, e :: directableIgnore :: []) ->
    //    //        extractChangeExprAndArguments e
    //    //    | Call (None, methodInfo, arguments) ->
    //    //        methodInfo :> MemberInfo, arguments
    //    //    | PropertyGet (None, propertyInfo, indexerArguments) ->
    //    //        propertyInfo :> MemberInfo, indexerArguments
    //    //    | _ -> invalidOp ""
    //    //let changeDefinition, changeArguments = extractChangeExprAndArguments directableExpr
    //    //let change = { Change.Definition = changeDefinition; Arguments = changeArguments }
    //    //history <- { history with Changes = List.append history.Changes [change] }
    //    //printfn "%A" history
    //    //body Unchecked.defaultof<'T>
    //    //let change = { Change.Expr = directableExpr }
    //    //{ Timeline.History = { History.Changes = [change] } }
    //    //Directable.expr directableExpr
    //    //|> Directable.unwrap
    //    //|> Directable.bind body

    //member this.Zero () : unit =
    //    ()
    //    //{ Timeline.History = history }

    //member this.Run _ : Timeline =
    //    Timeline (history)

    //member this.For (source : Directive<'T>, body : 'T -> Directive<'U>) : unit =
    //    ()

    //member this.Yield (expr : 'T) =
    //    ()

    //[<CustomOperation ("enact", MaintainsVariableSpace = true)>]
    //member this.Enact (source : unit, [<ProjectionParameter; ReflectedDefinition (true)>] alterationExprWithValue : Expr<unit -> DirectiveInvocation<unit>>) : unit =
    //    ()