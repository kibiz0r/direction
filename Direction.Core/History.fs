namespace Direction.Core

open System

type History = {
    Head : RevisionId
    RevisionGraph : RevisionGraph
}

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module History =
    let empty =
        { Head = RevisionId.empty; RevisionGraph = RevisionGraph.empty }

    let revise revisionId revision history : History =
        let revisionGraph = RevisionGraph.add revisionId revision history.RevisionGraph
        { Head = revisionId; RevisionGraph = revisionGraph }