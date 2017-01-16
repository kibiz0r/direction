namespace Direction.Dsl

open System

// DirectiveInvocation accumulates the deltas that arise from a single invocation of a DirectiveDefinition
// It is the return type of a directive { } block
type DirectiveInvocation<'T> () =
    class
    end
