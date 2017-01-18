namespace Direction.Runtime

open System
open System.Reflection
open Direction.Core

type Timeframe = {
    RevisionGraphs : Map<RevisionId, RevisionGraph>
    RevisionStates : Map<Revision, RevisionState>
}

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module Timeframe =
    let empty : Timeframe =
        { RevisionGraphs = Map.empty; RevisionStates = Map.empty }

    //let change (guidGenerator : unit -> Guid) (this : TimeframeObject<'T>) : Timeframe =
    //    empty

    let revisionGraph (headId : RevisionId) (timeframe : Timeframe) : RevisionGraph =
        if headId = RevisionId.empty then
            RevisionGraph.empty
        else
            timeframe.RevisionGraphs.[headId]

    let revision (headId : RevisionId) (revisionId : RevisionId) (timeframe : Timeframe) : Revision =
        (revisionGraph headId timeframe).[revisionId]

    let history (headId : RevisionId) (timeframe : Timeframe) : History =
        { Head = headId; RevisionGraph = revisionGraph headId timeframe }

    let revise (headId : RevisionId) (revisionId : RevisionId) (revision : Revision) (revisionState : RevisionState) (timeframe : Timeframe) : Timeframe =
        let revisionGraph = revisionGraph headId timeframe |> RevisionGraph.add revisionId revision
        let revisionGraphs = Map.add revisionId revisionGraph timeframe.RevisionGraphs
        let revisionStates = Map.add revision revisionState timeframe.RevisionStates
        {
            RevisionGraphs = revisionGraphs
            RevisionStates = revisionStates
        }

    //let commit (revisionId : RevisionId) (revision : Revision) (timeframe : Timeframe) : Timeframe =
    //    let timelineState =
    //        let timelineState = timeframe.TimelineStates.[timeline]
    //        let revisionStates = timelineState.RevisionStates.[revisionId]
    //        { timelineState with Head = revisionId; RevisionStates = revisionStates }
    //    { timeframe with TimelineStates = Map.add timeline timelineState timeframe.TimelineStates }
        //let changeDefinition = change.Definition
        //let returnValue =
        //    match changeDefinition with
        //    | :? MethodInfo as methodInfo ->
        //        methodInfo.Invoke (null, [||])
        //    | _ -> invalidOp ""