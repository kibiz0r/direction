namespace Direction.Core

open System

// A Timeframe is a container for all of the state necessary to evaluate
// an arbitrary Definition
[<StructuralEquality; StructuralComparison>]
type Timeframe = {
    ChangeResults : Map<ChangeId, ChangeResult>
    EffectResults : Map<EffectId, EffectResult>
}

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module Timeframe =
    let empty =
        { ChangeResults = Map.empty; EffectResults = Map.empty }

    let changeResult id timeframe =
        timeframe.ChangeResults.[id]

    let addChange id result timeframe =
        {
            ChangeResults = Map.add id result timeframe.ChangeResults
            EffectResults = timeframe.EffectResults
        }