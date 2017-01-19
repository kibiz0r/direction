namespace Direction.Core

open System

type ChangeId = Guid

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module ChangeId =
    let empty =
        Guid.Empty : ChangeId

    let random () =
        Guid.NewGuid () : ChangeId

    let int (i) =
        Guid (i, 0s, 0s, Array.zeroCreate 8) : ChangeId