namespace Direction.Core

open System

type ChangeResult =
    | ChangeSuccess of obj * EffectDefinition list
    | ChangeFailure of Exception
