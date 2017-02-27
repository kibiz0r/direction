namespace Direction.Runtime

open System
open FSharp.Quotations
open Direction.Core

//[<AutoOpen; CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
//module Director =
//    type IDirector with
//        member this.Enact ([<ReflectedDefinition>] expr : Expr<Enactment<'T>>, timeframe : Timeframe) : IDirective<'T> =
//            this.EnactExpr (expr, timeframe)

//        member this.EnactExpr (expr : Expr<Enactment<'T>>, timeframe : Timeframe) : IDirective<'T> =
//            let definition = this.Define expr
//            let id = this.Id definition
//            let change = { Definition = definition; Timeframe = timeframe }
//            let result = this.Evaluate change
//            let newTimeframe = Timeframe.addChange id result timeframe
//            Directive<'T> (id, definition, newTimeframe) :> IDirective<'T>