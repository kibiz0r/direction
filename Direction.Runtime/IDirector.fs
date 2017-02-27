namespace Direction.Runtime

open System
open Direction.Core

// 
type IDirector =
    abstract member Id : ChangeDefinition -> ChangeId
    abstract member Id : EffectDefinition -> EffectId

    abstract member Evaluate : Change -> ChangeResult

    abstract member Merge : Set<Timeframe> -> Timeframe