namespace Direction.Runtime

open System
open Direction.Core
open FSharp.Quotations

type Directive (id : ChangeId, definition : ChangeDefinition, timeframe : Timeframe) =
    interface IDirective with
        member this.Id = id
        member this.Definition = definition
        member this.Timeframe = timeframe

type Directive<'T> (id : ChangeId, definition : ChangeDefinition, timeframe : Timeframe) =
    inherit Directive (id, definition, timeframe)
    interface IDirective<'T>

[<AutoOpen; CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module Directive =
    type IDirective with
        member this.Result : ChangeResult =
            Timeframe.changeResult this.Id this.Timeframe

        member this.Value : obj =
            match this.Result with
            | ChangeSuccess (obj, _) ->
                obj
            | ChangeFailure e ->
                raise e

    type IDirective<'T> with
        member this.Value : 'T =
            match this.Result with
            | ChangeSuccess (obj, _) ->
                obj :?> 'T
            | ChangeFailure e ->
                raise e