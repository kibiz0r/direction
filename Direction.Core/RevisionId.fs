namespace Direction.Core

open System

type RevisionId = Guid

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module RevisionId =
    let empty =
        Guid.Empty : RevisionId

    let random () =
        Guid.NewGuid () : RevisionId

    let int (i) =
        Guid (i, 0s, 0s, Array.zeroCreate 8) : RevisionId