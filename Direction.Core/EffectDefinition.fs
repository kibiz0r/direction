namespace Direction.Core

open System
open Divination

[<StructuralEquality; StructuralComparison>]
type EffectDefinition = {
    Identity : Identity
}

type EffectId = int