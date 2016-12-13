namespace Direction

open System
open FSharp.Quotations

type TimelineBuilder () =
    member this.Bind (a : Directive<'T>, b : 'V -> 'W) : Timeline =
        Timeline ()

    member this.Return (f : 'T) : Timeline =
        Timeline ()

    member this.Zero () =
        Timeline ()

    member this.Yield (_ : 'T) : Timeline =
        Timeline ()

    member this.Quote (expr : Expr) =
        expr

    member this.Run (expr : Expr) : Timeline =
        Timeline ()

    //[<CustomOperation("enact")>]
    //member this.Enact (source : Timeline, directive : DirectiveDefinition<'T, 'U>, argument : 'T) : Directive<'U> =
    //    Directive<'U> ()

    //[<CustomOperation("alter")>]
    //member this.Alter (source : Timeline, delta : DeltaDefinition<'T>, argument : 'T) : Delta =
    //    Delta ()

    //[<CustomOperation("create")>]
    //member this.Create (source : Timeline, constructor' : 'T, argument : 'U) =
    //    obj ()