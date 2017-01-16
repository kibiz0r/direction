namespace Direction.Runtime

open System
open Direction.Data

type EffectRevision = {
    This : RevisionExpr option
    Definition : RevisionExpr
    Arguments : RevisionExpr list
} with
    interface IRevision

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module EffectRevision =
    let fromData (revisionId : RevisionId) (data: EffectRevisionData) : EffectRevision =
        {
            This = None
            Definition = RevisionIdExpr (RevisionId.NewGuid ())
            Arguments = []
        }