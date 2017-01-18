namespace Direction.Dsl

open System

type TimeLens (timeline : Timeline, timeframe : Timeframe) =
    let mutable timeframe = timeframe

    member this.Timeline = timeline
    member this.Timeframe = timeframe

    member this.Commit (revisionId : RevisionId, revision : IRevision) : unit =
        timeframe <- Timeframe.commit timeline revisionId revision timeframe