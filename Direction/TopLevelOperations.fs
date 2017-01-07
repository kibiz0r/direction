namespace Direction

open System
open Divination

[<AutoOpen>]
module TopLevelOperations =
    let timeline (history : History) = TimelineBuilder history
    let directive = DirectiveBuilder ()