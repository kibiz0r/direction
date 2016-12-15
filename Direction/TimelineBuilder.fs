namespace Direction

open System
open FSharp.Quotations

type TimelineBuilder () =
    member this.Bind (directive : Directive<'T>, f : 'T -> Directive<'U>) : Directive<'U> =
        Directive<'U> ()

    member this.Return (f : 'T) : Directive<'T> =
        Directive<'T> ()

    member this.Zero<'T> () =
        Directive<'T> ()

    member this.Yield (_ : 'T) : int =
        5

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