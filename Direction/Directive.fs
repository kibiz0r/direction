namespace Direction

open System

type Directive<'T> () =
    class
    inherit Directable<'T> ()
    end
