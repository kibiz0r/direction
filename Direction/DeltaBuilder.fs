namespace Direction

open System
open FSharp.Quotations

type DeltaBuilder () =
    member this.Bind (delta : Delta, func : 'T -> Delta) : Delta =
        Delta ()

    member this.Zero () : Delta =
        Delta ()

    member this.Yield (v : 'T) : Delta =
        Delta ()

    member this.Return (v : 'T) =
        Delta ()

    member this.Quote (expr : Expr) : Expr =
        expr

    member this.Run (expr : Expr<Delta>) : Delta =
        Delta ()

    [<CustomOperation("alter")>]
    member this.Alter (source : Delta, t : 'T) : Delta =
        Delta ()