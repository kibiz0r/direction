namespace Direction.Data

open System
open System.Runtime.Serialization

// I'm not sure exactly how this will work yet, but the idea is that any revisions older that the current head (or an
// arbitrary revision) will be effectively erased, and anything that still-extant revisions depend on will be directly
// serialized to storage so they can be deserialized into the runtime later without replaying any revisions
type SnapshotRevisionData = {
    Captured : Map<RevisionExpr, ISerializable>
}
