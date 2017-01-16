namespace Direction.Runtime

open System
open Direction.Data

module Revision =
    let fromData (revisionId : RevisionId) (revisionData : RevisionData) : IRevision =
        match revisionData with
            | ChangeRevisionData changeData ->
                ChangeRevision.fromData revisionId changeData :> _
            | EffectRevisionData effectData ->
                EffectRevision.fromData revisionId effectData :> _
            | SnapshotRevisionData snapshotData ->
                SnapshotRevision.fromData revisionId snapshotData :> _