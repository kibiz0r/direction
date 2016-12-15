namespace Direction

open System

[<AutoOpen>]
module TopLevelOperations =
    let timeline = TimelineBuilder ()
    let directive = DirectiveBuilder ()
    let delta = DeltaBuilder ()

    let enact (source : 'T -> DirectiveBody<'U>) (argument : 'T) : Directive<'U> =
        raise (InvalidOperationException "This is a marker method and should not be invoked outside of a `timeline` or `directive` expression.")

    let alter (source : 'T -> DeltaBody) (argument : 'T) : Delta =
        raise (InvalidOperationException "This is a marker method and should not be invoked outside of a `timeline`, `directive`, or `delta` expression.")

    let create (ctor : 'T -> 'U) (argument : 'T) : Directive<'U> =
        raise (InvalidOperationException "This is a marker method and should not be invoked outside of a `timeline`, `directive` expression.")