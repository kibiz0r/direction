namespace Direction.Test

open System
open System.Reflection
open NUnit.Framework
open FsUnit
open Direction
open Divination
open FSharp.Quotations.Patterns

[<TestFixture>]
module TimelineBuilderTest =
    let unitDirective = Directive<unit> (fun () -> ()) :> IDirectable<unit>
    let intDirective = Directive<int> (fun () -> 1) :> IDirectable<int>

    let callToGetIntDirective x =
        intDirective

    //let enact ([<ReflectedDefinition>] definitionExpr : Expr<'T -> DirectiveDefinition<'U>>) ([<ReflectedDefinition>] argumentExpr : Expr<'T>) : DirectiveInvocation<'U> =
    //    ()

    

    [<Test>]
    let ``the dogs out`` () =
        let timeline =
            timeline { Changes = [] } {
                let! i = intDirective
                do! intDirective |> Directable.ignore
                let! i2 = callToGetIntDirective 5
                do! unitDirective
            }
        let memberInfo expr =
            match expr with
            | Call (_, m, _) -> m :> MemberInfo
            | PropertyGet (_, p, _) -> p :> MemberInfo
            | _ -> invalidOp ""
        let intDirectiveInfo = memberInfo <@ intDirective @>
        let callToGetIntDirectiveInfo = memberInfo <@ callToGetIntDirective 5 @>
        let unitDirectiveInfo = memberInfo <@ unitDirective @>
        let fiveExpr = <@ 5 @>
        timeline.History.Changes |> should equal [
            { Change.Definition = intDirectiveInfo; Arguments = [] }
            { Change.Definition = intDirectiveInfo; Arguments = [] }
            { Change.Definition = callToGetIntDirectiveInfo; Arguments = [fiveExpr] }
            { Change.Definition = unitDirectiveInfo; Arguments = [] }
        ]