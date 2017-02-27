namespace Direction.Runtime

open System
open Direction.Core

type Enactment<'T> () =
    class
    end

type EnactmentBuilder () =
    member this.Return ()

[<AutoOpen; CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module Enactment =
    let enact = EnactmentBuilder ()