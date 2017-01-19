namespace Direction.Runtime

open System
open Direction.Core

type Timeframe = {
    ChangeDefinitions : Map<ChangeId, ChangeDefinition>
    ChangeResults : Map<ChangeDefinition, ChangeResult>
}

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module Timeframe =
    let empty =
        { ChangeDefinitions = Map.empty; ChangeResults = Map.empty }

    let change changeId changeDefinition changeResult timeframe =
        {
            ChangeDefinitions = Map.add changeId changeDefinition timeframe.ChangeDefinitions
            ChangeResults = Map.add changeDefinition changeResult timeframe.ChangeResults
        }

    let definition changeId timeframe =
        timeframe.ChangeDefinitions.[changeId]

    let result changeId timeframe =
        timeframe.ChangeResults.[changeId]

    let history headId timeframe =
        { Head = headId; ChangeDefinitions = timeframe.ChangeDefinitions }
