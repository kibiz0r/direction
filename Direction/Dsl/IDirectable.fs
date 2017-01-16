namespace Direction.Dsl

open System
open Divination

type IDirectable<'T> =
    inherit IDivinable<'T>
