namespace Direction

open System
open Divination

type DirectiveDefinition<'ArgumentType, 'ReturnType> (divinableMethod : IDivinable<'ArgumentType -> 'ReturnType>) =
    interface IDirectiveDefinition<'ReturnType>