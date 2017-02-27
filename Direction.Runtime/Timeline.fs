namespace Direction.Core

open System

// A Timeline specifies a particular Director, and caches the Directives
// associated with particular ChangeIds.
// 
// The cached Directives were not necessarily evaluated using the same
// Director, nor were their Ids necessarily computed by this Director, as
// they could've been adopted from another Timeline.
type Timeline = {
    Director : IDirector
    Directives : Map<ChangeId, IDirective>
}

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module Timeline =
    let directive (changeId : ChangeId) (timeline : Timeline) : IDirective =
        timeline.Directives.[changeId]

    // Computes all of the Directives that are not dependencies of other
    // Directives.
    let heads (timeline : Timeline) : Set<ChangeId> =
        Set.empty

    // Computes a Timeframe that is the result of merging the Timeframes of
    // all head Directives within the Timeline.
    // This is useful for persistence, but is not necessarily representative
    // of the Timeframe in which any particular Change would be evaluated
    // in, because a Change may depend on multiple ChangeIds, which don't
    // necessarily have a common lineage.
    let timeframe (timeline : Timeline) : Timeframe =
        heads timeline
        |> Set.map (fun changeId -> (directive changeId timeline).Timeframe)
        |> timeline.Director.MergeTimeframes

//type Timeline (history : History, processor : ITimelineProcessor) =
//    let mutable state = TimelineState.fromHistory history

//    member this.Revise (revisionId : RevisionId, revision : Revision) : RevisionState =
//        let value =
//            match revision with
//            | ChangeRevision change ->
//                Diviner.resolve diviner change.Identity
//            | _ -> invalidOp ""
//        RevisionState.ChangeRevisionState (ChangeRevisionValueState value)

//    member this.Change (changeDefinition : ChangeDefinition<'T>) : Change<'T> =
//        Unchecked.defaultof<Change<'T>>