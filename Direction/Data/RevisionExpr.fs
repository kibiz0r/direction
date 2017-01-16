namespace Direction.Data

open System

type RevisionExpr =
    | RevisionIdExpr of RevisionId
    | CallExpr of RevisionExpr option * MethodInfoData * RevisionExpr list