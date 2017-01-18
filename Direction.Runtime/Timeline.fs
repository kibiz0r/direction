namespace Direction.Runtime

open System
open Direction.Core
open Divination

type Timeline (history : History, diviner : IDiviner) =
    let mutable state = TimelineState.fromHistory history

    member this.Revise (revisionId : RevisionId, revision : Revision) : RevisionState =
        let value =
            match revision with
            | ChangeRevision change ->
                Diviner.resolve diviner change.Identity
            | _ -> invalidOp ""
        RevisionState.ChangeRevisionState (ChangeRevisionValueState value)