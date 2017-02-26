namespace Direction.Core

open System
open Divination

// A ChangeDefinition represents a replayable Change, which may be any kind
// of Identity
[<StructuralEquality; StructuralComparison>]
type ChangeDefinition = {
    Identity : Identity
}

type ChangeId = int