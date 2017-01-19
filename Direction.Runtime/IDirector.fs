namespace Direction.Runtime

open System
open FSharp.Quotations

type IDirector =
    abstract member Change<'T> : Timeframe * Expr<'T> -> Change<'T>