namespace Direction

open System
open FSharp.Quotations

type DirectiveBuilder () =
    member this.Bind (directive : Directable<'T>, func : 'T -> Directive<'U>) : Directive<'U> =
        Directive<'U> ()

    member this.Zero () =
        Directive<unit> ()

    member this.Yield (v : 'T) : Directive<'T> =
        Directive<'T> ()

    member this.Return (v : 'T) : Directive<'T> =
        Directive<'T> ()

    member this.Quote (expr : Expr) =
        expr

    member this.Run (expr : Expr<Directive<'T>>) : Directive<'T> =
        Directive<'T> ()

    //[<CustomOperation("enact")>]
    //member this.Enact (source : DirectiveDefinition<'T, 'U>, directive : DirectiveDefinition<'V, 'W>) : Directive<'W> =
    //    Directive<'U> ()

    //[<CustomOperation("alter")>]
    //member this.Alter (source : DirectiveDefinition<'T, 'U>, delta : DeltaDefinition<'V>, argument : 'V) : Delta =
    //    Delta ()