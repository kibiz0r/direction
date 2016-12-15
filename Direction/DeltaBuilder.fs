namespace Direction

open System
open FSharp.Quotations

type DeltaBuilder () =
    member this.Bind (delta : Delta, func : 'T -> DeltaBody) : DeltaBody =
        DeltaBody (Expr.Value (obj ()))

    member this.Zero () : DeltaBody =
        DeltaBody (Expr.Value (obj ()))

    member this.Yield (v : 'T) : DeltaBody =
        DeltaBody (Expr.Value (obj ()))

    member this.Return (v : 'T) =
        DeltaBody (Expr.Value (obj ()))

    member this.Quote (expr : Expr) : Expr =
        expr

    member this.Run (expr : Expr<DeltaBody>) : DeltaBody =
        DeltaBody (Expr.Value (obj ()))

    //[<CustomOperation("alter")>]
    //member this.Alter (source : Delta, t : 'T) : Delta =
    //    Delta ()