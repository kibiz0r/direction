namespace Direction.Runtime

open System
open Direction.Data

type ChangeRevision = {
    Id : RevisionId
    Expr : RevisionExpr
} with
    interface IRevision

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module ChangeRevision =
    let fromData (revisionId : RevisionId) (data: ChangeRevisionData) : ChangeRevision =
        {
            Id = revisionId
            Expr = data.Expr
        }