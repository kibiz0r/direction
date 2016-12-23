namespace Direction

open Divination

type TimeframeDiviningContext () =
    interface ITimeframeDiviningContext with
        member this.GetVar (name) =
            obj ()

        member this.SetVar (name, value) =
            TimeframeDiviningContext () :> IDiviningContext
