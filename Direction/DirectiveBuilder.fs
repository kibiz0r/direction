namespace Direction

open System
open FSharp.Quotations

type DirectiveBuilder () =
    member this.Bind (directive : Directive<'T>, func : 'T -> DirectiveBody<'U>) : DirectiveBody<'U> =
        DirectiveBody<'U> ()

    member this.Bind (delta : Delta, func : 'T -> DirectiveBody<'U>) : DirectiveBody<'U> =
        DirectiveBody<'U> ()

    member this.Zero () : DirectiveBody<'T> =
        DirectiveBody<'T> ()

    member this.Delay (f : unit -> DirectiveBody<'T>) : DirectiveBody<'T> =
        DirectiveBody<'T> ()

    member this.Combine (body1 : DirectiveBody<'T>, body2 : DirectiveBody<'T>) : DirectiveBody<'T> =
        DirectiveBody<'T> ()

    member this.While (guard : unit -> bool, source : DirectiveBody<'T>) : DirectiveBody<'T> =
        DirectiveBody<'T> ()

    member this.Yield (v : 'T) : DirectiveBody<'T> =
        DirectiveBody<'T> ()

    member this.Return (v : 'T) : DirectiveBody<'T> =
        DirectiveBody<'T> ()

    member this.Quote (expr : Expr) =
        expr

    member this.Run (expr : Expr<DirectiveBody<'T>>) : DirectiveBody<'T> =
        DirectiveBody<'T> ()

    //[<CustomOperation("enact")>]
    //member this.Enact (source : DirectiveDefinition<'T, 'U>, directive : DirectiveDefinition<'V, 'W>) : Directive<'W> =
    //    Directive<'U> ()

    //[<CustomOperation("alter")>]
    //member this.Alter (source : DirectiveDefinition<'T, 'U>, delta : DeltaDefinition<'V>, argument : 'V) : Delta =
    //    Delta ()