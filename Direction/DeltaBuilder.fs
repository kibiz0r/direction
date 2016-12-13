namespace Direction

open System
open FSharp.Quotations

type DeltaBuilder () =
    member this.Bind (delta : Delta, func : 'T -> DeltaBody) : DeltaBody =
        DeltaBody ()

    member this.Zero () : DeltaBody =
        DeltaBody ()

    member this.Yield (v : 'T) : DeltaBody =
        DeltaBody ()

    member this.Return (v : 'T) =
        DeltaBody ()

    member this.Quote (expr : Expr) : Expr =
        expr

    member this.Run (expr : Expr<DeltaBody>) : DeltaBody =
        DeltaBody ()

    //[<CustomOperation("alter")>]
    //member this.Alter (source : Delta, t : 'T) : Delta =
    //    Delta ()