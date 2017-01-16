namespace Direction.Runtime

open System
open Direction.Data

type TimeState = {
    Directeds : Map<RevisionId, obj>
}
