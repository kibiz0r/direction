namespace Direction.Core

open System
open Direction.Data

type History () =
    let mutable historyData : HistoryData =
        {
            Head = RevisionId.Empty
            Revisions = Map.empty
        }

    member this.Head =
        historyData.Head

    member this.Revisions =
        historyData.Revisions

    member this.CommitRevision (revisionData : RevisionData) : IRevision =
        let revisionId = RevisionId.NewGuid ()
        historyData <- historyData |> HistoryData.commit revisionId revisionData
        Revision.fromData revisionId revisionData

    member this.CommitChange (changeRevisionData : ChangeRevisionData) : ChangeRevision =
        this.CommitRevision (ChangeRevisionData changeRevisionData) :?> ChangeRevision

    member this.GetRevision (revisionId : RevisionId) : IRevision =
        let revisionData = historyData.Revisions.[revisionId]
        Revision.fromData revisionId revisionData

    member this.GetChange (changeId : RevisionId) : ChangeRevision =
        this.GetRevision changeId :?> ChangeRevision

    member this.EvalChange (changeRevision : ChangeRevision) : obj =
        match changeRevision.Expr with
            | CallExpr (None, methodInfoData, arguments) ->
                let methodInfo = MethodInfoData.toMethodInfo methodInfoData
                methodInfo.Invoke (null, [||])
            | _ -> invalidOp ""

    member this.EvalChangeId (changeId : RevisionId) : obj =
        let change = this.GetChange changeId
        this.EvalChange change

    member this.Change (expr : RevisionExpr) : obj =
        this.CommitChange { ChangeRevisionData.Expr = expr } |> this.EvalChange

    static member FromData (data : HistoryData) : History =
        let head = data.Head
        let revisions = data.Revisions |> Map.map (fun revisionId -> Revision.fromData revisionId)
        History ()
