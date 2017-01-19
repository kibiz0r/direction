namespace Direction.Runtime

open System
open FSharp.Quotations
open Direction.Core

type IDirector =
    abstract member Change<'T> : Timeframe * Expr<'T> -> Change<'T>