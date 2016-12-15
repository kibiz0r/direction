namespace Direction

open System
open FSharp.Quotations

type DeltaBody (expr : Expr) =
    member this.Expr = expr