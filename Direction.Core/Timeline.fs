namespace Direction.Core

open System

type Timeline = {
    HeadId : ChangeId
    Timeframe : Timeframe
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