namespace Direction.Runtime

open System
open FSharp.Quotations
open Direction.Core

type Change<'T> (timeline : Timeline) =
    let id = timeline.Head
    let timeframe = timeline.Timeframe
    let definition = Timeframe.definition id timeframe
    let result = Timeframe.result definition timeframe

    member this.Timeline = timeline

    member this.Id = id
    member this.Timeframe = timeframe
    member this.Definition = definition
    member this.Result = result

    member this.Value =
        match result with
        | ChangeReturnValue v -> v
        | ChangeException e -> raise e