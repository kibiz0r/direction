namespace Direction.Runtime

open System
open System.Reflection
open Direction.Core
open Divination

module Thingy =
    let evalChange (change : Change) (resolveMethod : MethodDefinition -> MethodInfo) (resolveIdentity : Identity -> obj) : ChangeResult =
        try
            let this =
                match change.This with
                | Some t -> resolveIdentity t
                | None -> null
            let method' = resolveMethod change.Definition
            let arguments = List.map resolveIdentity change.Arguments
            ChangeReturnValue (method'.Invoke (this, List.toArray arguments))
        with
            | e -> ChangeException e