namespace Direction.Dsl

open System
open Direction.Runtime

type Timeline (history : History) =
    member this.InvokeDirective (directiveInvocation : DirectiveInvocation<'T>) : Directive<'T> =
        Directive<'T> ()