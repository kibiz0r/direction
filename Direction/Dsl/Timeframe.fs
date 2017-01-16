namespace Direction.Dsl

open System
open System.Reflection
open Direction.Runtime

type Timeframe = {
    Timeline : Timeline
}

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module Timeframe =
    let empty : Timeframe =
        { Timeline = Timeline (History ()) }

    //let change (guidGenerator : unit -> Guid) (this : TimeframeObject<'T>) : Timeframe =
    //    empty

    let commit (change : ChangeRevision) (timeframe : Timeframe) : Timeframe =
        //let changeDefinition = change.Definition
        //let returnValue =
        //    match changeDefinition with
        //        | :? MethodInfo as methodInfo ->
        //            methodInfo.Invoke (null, [||])
        //        | _ -> invalidOp ""
        empty