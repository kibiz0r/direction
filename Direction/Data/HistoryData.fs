namespace Direction.Data

open System

type HistoryData = {
    Head : RevisionId
    Revisions : Map<RevisionId, RevisionData>
}

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module HistoryData =
    let empty : HistoryData =
        {
            Head = RevisionId.Empty
            Revisions = Map.empty
        }

    let commit (revisionId : RevisionId) (revisionData : RevisionData) (historyData : HistoryData) : HistoryData =
        let revisions = historyData.Revisions |> Map.add revisionId revisionData
        {
            Head = revisionId
            Revisions = revisions
        }