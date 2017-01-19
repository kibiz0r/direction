namespace Direction.Core

open System
open Divination

[<StructuralEquality; StructuralComparison>]
type RevisionDefinition =
    | ChangeDefinition of ChangeDefinition
    | EffectDefinition of EffectDefinition
    //| SnapshotRevision of Snapshot
