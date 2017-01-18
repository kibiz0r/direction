namespace Direction.Dsl

open System
open Direction.Runtime
open Direction.Core

[<AutoOpen>]
module TopLevelOperations =
    let timeline (history : History) = TimelineBuilder history
    let directive = DirectiveBuilder ()