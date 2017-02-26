namespace Direction.Core

open System

// A Timeline specifies a particular Director, and caches the Directives
// associated with a particular ChangeId.
// 
// The cached Directives were not necessarily evaluated using the same
// Director, but their Ids were computed using this Timeline's Director.
type Timeline = {
    Director : IDirector
    Directives : Map<ChangeId, IDirective>
}

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