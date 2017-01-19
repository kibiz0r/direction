namespace Direction.Core

open System

type History = {
    HeadId : ChangeId
    ChangeDefinitions : Map<ChangeId, ChangeDefinition>
}

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module History =
    let empty =
        { HeadId = ChangeId.empty; ChangeDefinitions = Map.empty }

    let change changeId changeDefinition history =
        { HeadId = changeId; ChangeDefinitions = Map.add changeId changeDefinition history.ChangeDefinitions }

    let definition changeId history =
        history.ChangeDefinitions.[changeId]

    let head history =
        definition history.HeadId

    //let revise revisionId revision history : History =
    //    let revisionGraph = RevisionGraph.add revisionId revision history.RevisionGraph
    //    { Head = revisionId; RevisionGraph = revisionGraph }