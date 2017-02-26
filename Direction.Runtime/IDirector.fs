namespace Direction.Runtime

open System
open FSharp.Quotations
open Direction.Core

// 
type IDirector =
    abstract member Id : ChangeDefinition -> ChangeId
    abstract member Id : EffectDefinition -> EffectDefinition

    abstract member Parents : ChangeDefinition -> Set<ChangeId>
    abstract member Parents : EffectDefinition -> Set<EffectDefinition>

    abstract member Timeframe : Expr -> Timeframe
    abstract member ChangeDefinition : Expr -> ChangeId * ChangeDefinition
    abstract member Change<'T> : Timeframe * ChangeId * ChangeDefinition -> Change<'T>
with
    member this.Enact ([<ReflectedDefinition>] changeExpr : Expr<'T>, timeframe : Timeframe) : IDirective<'T> =
        this.EnactExpr (changeExpr, timeframe)

    member this.EnactExpr (changeExpr : Expr<'T>, timeframe : Timeframe) : IDirective<'T> =
        let changeDefinition = this.ChangeDefinition changeExpr
        let changeId = this.Id changeDefinition
        let changeResult = this.Evaluate (changeDefinition, timeframe)
        let newTimeframe = Timeframe.add changeId changeResult timeframe
        Directive<'T> (changeId, changeDefinition, newTimeframe)