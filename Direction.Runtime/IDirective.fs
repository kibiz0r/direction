namespace Direction.Runtime

open System
open Direction.Core

// A Directive represents the evaluated form of a ChangeDefinition, after
// being passed to a specific Director with a given Timeframe.
// The Id is assumed to point to a ChangeResult and associated EffectResults
// in the Timeframe, and is also assumed to match the Id that the Director
// would compute for the Definition.
type IDirective =
    abstract member Id : ChangeId
    abstract member Definition : ChangeDefinition
    abstract member Timeframe : Timeframe

type IDirective with
    member this.Result : ChangeResult =
        Timeframe.changeResult this.Id this.Timeframe

    member this.Value : obj =
        match this.Result with
        | ChangeSuccess (obj, _) ->
            obj
        | ChangeFailure e ->
            failWith e

type IDirective<'T> =
    inherit IDirective

type IDirective<'T> with
    member this.Value : 'T =
        match this.Result with
        | ChangeSuccess (obj, _) ->
            obj :?> 'T
        | ChangeFailure e ->
            failWith e