namespace Direction.Core

open System

type RevisionGraph = Map<RevisionId, Revision>

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module RevisionGraph =
    let empty =
        Map.empty : RevisionGraph

    let add key value (revisionGraph : RevisionGraph) =
        Map.add key value revisionGraph : RevisionGraph

    let ofList elements =
        Map.ofList elements : RevisionGraph