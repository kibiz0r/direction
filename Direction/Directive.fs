namespace Direction

open System

type Directive<'T> () =
    static member Enact (definition : DirectiveDefinition<'T, 'U>, argument : 'T) =
        Directive<'U> ()