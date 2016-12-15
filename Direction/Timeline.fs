namespace Direction

open System

type Timeline () =
    member this.GetDirected<'T> (name : string) =
        Directed<'T> (this, name)

    member this.GetDirectedValue<'T> (name : string) =
        Unchecked.defaultof<'T>

    member this.Item
        with get (name) = this.GetDirected name

and Directed<'T> (timeline : Timeline, name : string) =
    member this.Value = timeline.GetDirectedValue<'T> name
