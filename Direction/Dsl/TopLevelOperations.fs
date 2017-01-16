namespace Direction.Dsl

open System
open Divination
open Direction.Runtime

[<AutoOpen>]
module TopLevelOperations =
    let timeline (history : History) = TimelineBuilder history
    let directive = DirectiveBuilder ()