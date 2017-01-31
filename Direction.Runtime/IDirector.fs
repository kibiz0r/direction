namespace Direction.Runtime

open System
open FSharp.Quotations
open Direction.Core

type IDirector =
    abstract member Timeframe : Expr -> Timeframe
    abstract member ChangeDefinition : Expr -> ChangeId * ChangeDefinition
    abstract member Change<'T> : Timeframe * ChangeId * ChangeDefinition -> Change<'T>