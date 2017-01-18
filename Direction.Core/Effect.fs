namespace Direction.Core

open System
open Divination

[<StructuralEquality; StructuralComparison>]
type Effect = {
    This : Identity option
    Definition : MethodDefinition
    Arguments : Identity list
}
