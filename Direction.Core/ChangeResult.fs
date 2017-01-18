namespace Direction.Core

open System

type ChangeResult =
    | ChangeReturnValue of obj
    | ChangeException of Exception
