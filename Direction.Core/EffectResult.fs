namespace Direction.Core

open System
open System.Collections

[<CustomEquality; CustomComparison>]
type EffectResult =
    | EffectSuccess
    | EffectFailure of Exception
with
    override this.Equals other =
        match other with
        | :? EffectResult as o ->
            (this :> IEquatable<EffectResult>).Equals o
        | _ -> false

    override this.GetHashCode () =
        match this with
        | EffectSuccess ->
            0
        | EffectFailure e ->
            e.GetHashCode ()

    interface IEquatable<EffectResult> with
        member this.Equals other =
            match this, other with
            | EffectSuccess, EffectSuccess ->
                true
            | EffectFailure e, EffectFailure e2 ->
                e.Equals e2
            | _ -> false

    interface IComparable<EffectResult> with
        member this.CompareTo other =
            let comparisonObj identity =
                match identity with
                | EffectSuccess ->
                    null
                | EffectFailure e ->
                    e :> obj
            Comparer.Default.Compare (comparisonObj this, comparisonObj other)

    interface IComparable with
        member this.CompareTo other =
            (this :> IComparable<EffectResult>).CompareTo (other :?> EffectResult)