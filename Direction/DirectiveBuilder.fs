namespace Direction

open System
open FSharp.Quotations

type DirectiveBuilder () =
    member this.Bind (directive : Directive<'T>, func : 'T -> DirectiveBody<'U>) : DirectiveBody<'U> =
        DirectiveBody<'U> (Expr.Value (obj ()) |> Expr.Cast)

    member this.Bind (delta : Delta, func : 'T -> DirectiveBody<'U>) : DirectiveBody<'U> =
        DirectiveBody<'U> (Expr.Value (obj ()) |> Expr.Cast)

    member this.Zero () : DirectiveBody<'T> =
        DirectiveBody<'T> (Expr.Value (obj ()) |> Expr.Cast)

    member this.Delay (f : unit -> DirectiveBody<'T>) : DirectiveBody<'T> =
        DirectiveBody<'T> (Expr.Value (obj ()) |> Expr.Cast)

    member this.Combine (body1 : DirectiveBody<'T>, body2 : DirectiveBody<'T>) : DirectiveBody<'T> =
        DirectiveBody<'T> (Expr.Value (obj ()) |> Expr.Cast)

    member this.While (guard : unit -> bool, source : DirectiveBody<'T>) : DirectiveBody<'T> =
        DirectiveBody<'T> (Expr.Value (obj ()) |> Expr.Cast)

    member this.Yield (v : 'T) : DirectiveBody<'T> =
        DirectiveBody<'T> (Expr.Value (obj ()) |> Expr.Cast)

    member this.Return (v : 'T) : DirectiveBody<'T> =
        DirectiveBody<'T> (Expr.Value (obj ()) |> Expr.Cast)

    member this.Quote (expr : Expr) =
        expr

    member this.Run (expr : Expr<DirectiveBody<'T>>) : DirectiveBody<'T> =
        DirectiveBody<'T> (Expr.Value (obj ()) |> Expr.Cast)

    //[<CustomOperation("enact")>]
    //member this.Enact (source : DirectiveDefinition<'T, 'U>, directive : DirectiveDefinition<'V, 'W>) : Directive<'W> =
    //    Directive<'U> ()

    //[<CustomOperation("alter")>]
    //member this.Alter (source : DirectiveDefinition<'T, 'U>, delta : DeltaDefinition<'V>, argument : 'V) : Delta =
    //    Delta ()