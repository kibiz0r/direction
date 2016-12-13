namespace Direction

open System

[<AutoOpen>]
module TopLevelOperations =
    let timeline = TimelineBuilder ()
    let directive = DirectiveBuilder ()
    let delta = DeltaBuilder ()

    let enact (source : 'T -> DirectiveBody<'U>) (argument : 'T) : Directive<'U> = Directive.Enact (source, argument)
    let enact' (source : 'T -> DirectiveBody<'U>) (argument : 'T) : 'U = Directive.EnactValue (source, argument)

    let alter (source : 'T -> DeltaBody) (argument : 'T) : Delta = Delta.Alter (source, argument)