namespace Direction.Core

open System
open Divination

[<StructuralEquality; StructuralComparison>]
type Snapshot = {
    Captured : Map<Identity, IComparable>
}
