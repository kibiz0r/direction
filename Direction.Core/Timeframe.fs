namespace Direction.Core

open System

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

    let tryDefinition changeId timeframe =
        Map.tryFind changeId timeframe.ChangeDefinitions

    let definition changeId timeframe =
        match tryDefinition changeId timeframe with
        | Some definition -> definition
        | None -> raise (MissingChangeDefinitionException ())

    let result changeId timeframe =
        timeframe.ChangeResults.[changeId]

    let history headId timeframe =
        { HeadId = headId; ChangeDefinitions = timeframe.ChangeDefinitions }
