namespace Direction.Core

open System

type EffectResult =
    | EffectSuccess
    | EffectFailure of Exception
