namespace Direction

open System
open Divination

[<AutoOpen>]
module TopLevelOperations =
    let timeline = TimelineBuilder ()
    let directive = DirectiveBuilder ()