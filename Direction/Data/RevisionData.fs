namespace Direction.Data

open System

type RevisionData =
    | ChangeRevisionData of ChangeRevisionData
    | EffectRevisionData of EffectRevisionData
    | SnapshotRevisionData of SnapshotRevisionData
