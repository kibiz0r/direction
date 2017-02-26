namespace Direction.Core

open System

// A Timeframe is a container for all of the state necessary to evaluate
// an arbitrary Definition
type Timeframe = {
    // Not sure it actually needs a History, and having one may be
    // problematic, because a Director may dispute how a History's
    // Definitions would've been Id'd as well as evaluated
    //History : History
    ChangeResults : Map<ChangeId, ChangeResult>
    EffectResults : Map<EffectId, EffectResult>
}

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module Timeframe =
    let empty =
        { ChangeResults = Map.empty; EffectResults = Map.empty }

    let changeResult id timeframe =
        timeframe.ChangeResults.[id]