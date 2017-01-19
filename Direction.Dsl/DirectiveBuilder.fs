namespace Direction.Dsl

open System
open FSharp.Quotations
open FSharp.Quotations.Evaluator
open FSharp.Quotations.Patterns
//open Divination
open Direction.Runtime

type DirectiveBuilder () =
    member this.Bind ([<ReflectedDefinition>] directiveExpr : Expr<Directive<'T>>, body : 'T -> Directive<'U>) : Directive<'U> =
        printfn "%A" directiveExpr
        Unchecked.defaultof<Directive<'U>>
        //Directive<'U> <| fun () ->
        //    let directive = directiveExpr |> QuotationEvaluator.Evaluate
        //    (body directive.Value).Value

    member this.Return ([<ReflectedDefinition>] valueExpr : Expr<'T>) : DirectiveInvocation<'T> =
        Unchecked.defaultof<DirectiveInvocation<'T>>
        //Directive<'T> <| fun () ->
        //    valueExpr |> QuotationEvaluator.Evaluate

    member this.For (source : Directive<'T>, body : 'T -> Directive<'U>) : Directive<'U> =
        Unchecked.defaultof<Directive<'U>>
        //Directive<'U> <| fun () ->
        //    (body source.Value).Value

    member this.Yield (expr : 'T) =
        Unchecked.defaultof<Directive<'T>>
        //Directive<'T> <| fun () -> expr

    [<CustomOperation ("alter", MaintainsVariableSpace = true)>]
    member this.Alter (source : Directive<'T>, [<ProjectionParameter; ReflectedDefinition (true)>] alterationExprWithValue : Expr<'T -> unit>) : Directive<'T> =
        Unchecked.defaultof<Directive<'T>>
        //match alterationExprWithValue with
        //| WithValue (_, _, (:? Expr<'T -> unit> as alterationExpr)) ->
        //    let alteration = alterationExpr |> QuotationEvaluator.Evaluate
        //    alteration source.Value
        //    source
        //| _ -> invalidOp ""

    //member this.Run (expr : 'T) : DirectiveInvocation<'T> =
    //    DirectiveInvocation<'T> ()
        //Directive<'T> <| fun () -> expr