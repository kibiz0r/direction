namespace Direction

open System
open Divination

type TimeframeDiviner () =
    interface IDiviner<TimeframeDiviningContext> with
        member this.Eval (divinedExpr, divineContext) =
            obj ()