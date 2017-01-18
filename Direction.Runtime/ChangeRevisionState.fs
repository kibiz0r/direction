namespace Direction.Runtime

open System

type ChangeRevisionState =
    | ChangeRevisionValueState of obj
    | ChangeRevisionException of exn