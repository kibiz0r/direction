namespace Direction.Dsl

open System
open Divination
open FSharp.Quotations

type Directive<'T> () =
    static member Enact (definitionExpr : Expr<'T>) : DirectiveInvocation<'T> =
        DirectiveInvocation<'T> ()

    interface IDirectable<'T>

    interface IDivinable<'T> with
        member this.Identify diviner =
            obj ()