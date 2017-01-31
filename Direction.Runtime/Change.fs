namespace Direction.Runtime

open System
open FSharp.Quotations
open Direction.Core

type Change<'T> (timeline : Timeline) =
    let id = timeline.HeadId
    let timeframe = timeline.Timeframe
    let definition () = Timeframe.definition id timeframe
    let result () = Timeframe.result (definition ()) timeframe

    let success () =
        match result () with
        | ChangeSuccess (v, e) -> v, e
        | ChangeFailure e -> raise e

    member this.Timeline = timeline

    member this.Id = id
    member this.Timeframe = timeframe
    member this.Definition = definition ()
    member this.Result = result ()

    member this.Value =
        fst (success ()) :?> 'T

    member this.Effects =
        snd (success ())