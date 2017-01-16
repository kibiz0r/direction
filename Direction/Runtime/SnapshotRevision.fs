namespace Direction.Runtime

open System
open System.Runtime.Serialization
open Direction.Data

type SnapshotRevision = {
    Captured : Map<RevisionExpr, ISerializable>
} with
    interface IRevision

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module SnapshotRevision =
    let fromData (revisionId : RevisionId) (data : SnapshotRevisionData) : SnapshotRevision =
        { SnapshotRevision.Captured = Map.empty }
