namespace Direction.Runtime

open System
open Direction.Core

type Enactment<'T> () =
    member this.Evaluate () : 'T * EffectDefinition list =
        Unchecked.defaultof<'T>, []