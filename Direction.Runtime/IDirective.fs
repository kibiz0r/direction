namespace Direction.Runtime

open System
open Direction.Core

// A Directive represents the evaluated form of a ChangeDefinition, after
// being passed to a specific Director with a given Timeframe.
// 
// The Id is assumed to point to a ChangeResult and associated EffectResults
// in the Timeframe.
type IDirective =
    abstract member Id : ChangeId
    abstract member Definition : ChangeDefinition
    abstract member Timeframe : Timeframe

type IDirective<'T> =
    inherit IDirective