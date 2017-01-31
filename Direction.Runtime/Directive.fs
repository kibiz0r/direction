namespace Direction.Runtime

open System
open Direction.Core
open FSharp.Quotations

type Directive<'T> (director : IDirector, change : Change<'T>) =
    let id = change.Id
    let timeline = change.Timeline
    let timeframe = change.Timeframe
    let definition = change.Definition
    let result = change.Result

    member this.Director = director
    member this.Change = change

    member this.Id = id
    member this.Timeline = timeline
    member this.Timeframe = timeframe
    member this.Definition = definition
    member this.Result = result

    member this.Value = change.Value

    static member EnactDefinition (director : IDirector, timeframe : Timeframe, changeId : ChangeId, changeDefinition : ChangeDefinition) : Directive<'T> =
        let change = director.Change (timeframe, changeId, changeDefinition)
        Directive<'T> (director, change)

    static member EnactExpr (director : IDirector, changeExpr : Expr<'T>) : Directive<'T> =
        let timeframe = director.Timeframe (changeExpr)
        let changeId, changeDefinition = director.ChangeDefinition (changeExpr)
        Directive.EnactDefinition (director, timeframe, changeId, changeDefinition)

    static member Enact (director : IDirector, [<ReflectedDefinition>] changeExpr : Expr<'T>) : Directive<'T> =
        Directive.EnactExpr (director, changeExpr)