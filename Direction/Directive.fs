namespace Direction

open System

type Directive<'T> (value : unit -> 'T) =
    let mutable _value : 'T option = None

    member this.Value =
        match _value with
        | Some v -> v
        | None ->
            _value <- Some (value ())
            _value.Value