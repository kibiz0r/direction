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

    static member EnactExpr (director : IDirector, timeframe : Timeframe, changeExpr : Expr<'T>) : Directive<'T> =
        let change = director.Change (timeframe, changeExpr)
        Directive<'T> (director, change)

    static member Enact (director : IDirector, timeframe : Timeframe, [<ReflectedDefinition>] changeExpr : Expr<'T>) : Directive<'T> =
        Directive.EnactExpr (director, timeframe, changeExpr)