namespace Direction.Core

open System
open System.Collections

[<CustomEquality; CustomComparison>]
type ChangeResult =
    | ChangeSuccess of obj * EffectDefinition list
    | ChangeFailure of Exception
with
    override this.Equals other =
        match other with
        | :? ChangeResult as o ->
            (this :> IEquatable<ChangeResult>).Equals o
        | _ -> false

    override this.GetHashCode () =
        match this with
        | ChangeSuccess (o, e) ->
            (o, e).GetHashCode ()
        | ChangeFailure (e) ->
            e.GetHashCode ()

    interface IEquatable<ChangeResult> with
        member this.Equals other =
            match this, other with
            | ChangeSuccess (o, e), ChangeSuccess (o2, e2) ->
                (o, e).Equals ((o2, e2))
            | ChangeFailure e, ChangeFailure e2 ->
                e.Equals e2
            | _ -> false

    interface IComparable<ChangeResult> with
        member this.CompareTo other =
            let comparisonObj identity =
                match identity with
                | ChangeSuccess (o, e) ->
                    (o, e) :> obj
                | ChangeFailure e ->
                    e :> obj
            Comparer.Default.Compare (comparisonObj this, comparisonObj other)

    interface IComparable with
        member this.CompareTo other =
            (this :> IComparable<ChangeResult>).CompareTo (other :?> ChangeResult)