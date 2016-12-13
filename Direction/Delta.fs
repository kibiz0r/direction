namespace Direction

open System

type Delta () =
    inherit Directable<unit> ()

    static member Alter (source : 'T -> DeltaBody, argument : 'T) =
        Delta ()
