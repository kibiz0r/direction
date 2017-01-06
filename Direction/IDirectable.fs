namespace Direction

open System
open Divination

type IDirectable<'T> =
    inherit IDivinable<'T>
