namespace Direction

open System

type Delta () =
    static member Alter (definition : DeltaDefinition<'T>, argument : 'T) =
        Delta ()
