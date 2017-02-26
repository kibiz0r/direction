namespace Direction.Core

open System

type EffectId = int

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module EffectId =
    let mutable randomSeed : int option = None
    let random () : EffectId =
        match randomSeed with
        | Some seed -> (Random seed).Next ()
        | None -> (Random ()).Next ()

    let zero : EffectId = 0

    let int (i) : EffectId = i

    let hash (effectDefinition : EffectDefinition) : EffectId =
        hash effectDefinition
