namespace Direction.Core

open System

[<StructuralEquality; StructuralComparison>]
type Revision =
    | ChangeRevision of Change
    | EffectRevision of Effect
    | SnapshotRevision of Snapshot
