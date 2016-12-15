namespace Direction

open System
open FSharp.Quotations

type DirectiveBody<'T> (expr : Expr<'T>) =
    member this.Expr = expr
