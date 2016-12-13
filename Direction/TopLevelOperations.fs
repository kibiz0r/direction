namespace Direction

open System

[<AutoOpen>]
module TopLevelOperations =
    let timeline = TimelineBuilder ()
    let directive = DirectiveBuilder ()
    let delta = DeltaBuilder ()