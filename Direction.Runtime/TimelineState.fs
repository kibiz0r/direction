namespace Direction.Runtime

open System
open Direction.Core

type TimelineState = {
    Head : RevisionId
    Timeframe : Timeframe
}

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module TimelineState =
    let empty : TimelineState =
        { Head = RevisionId.empty; Timeframe = Timeframe.empty }

    let fromHistory (history : History) : TimelineState =
        empty

    let revise (revisionId : RevisionId) (revision : Revision) (revisionState : RevisionState) (timelineState : TimelineState) : TimelineState =
        { Head = revisionId; Timeframe = Timeframe.revise timelineState.Head revisionId revision revisionState timelineState.Timeframe }
