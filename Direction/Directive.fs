namespace Direction

open System

type Directive<'T> () =
    inherit Directable<'T> ()

    static member Enact (source : 'T -> DirectiveBody<'U>, argument : 'T) =
        Directive<'U> ()

    static member EnactValue (source : 'T -> DirectiveBody<'U>, argument : 'T) =
        Unchecked.defaultof<'U>