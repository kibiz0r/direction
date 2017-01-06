namespace Direction

open System
open FSharp.Quotations
open FSharp.Quotations.Evaluator
open Divination

type TimelineBuilder () =
    member this.Bind ([<ReflectedDefinition>] directableExpr : Expr<IDirectable<'T>>, body : 'T -> Timeline) : Timeline =
        printfn "%A" directableExpr
        Timeline ()
        //Directable.expr directableExpr
        //|> Directable.unwrap
        //|> Directable.bind body

    member this.Zero () : Timeline =
        Timeline ()