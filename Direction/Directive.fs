namespace Direction

open System
open Divination

type Directive<'ReturnType> (definition : IDirectiveDefinition<'ReturnType>, argument : IDivinable) =
    interface IDivinable with
        member this.DivineExpr diviner =
            DivinedExpr.DivinedValue { DivinedValueExpr.Value = 5; TypeName = typeof<int>.AssemblyQualifiedName }

    interface IDivinable<'ReturnType> with
        member this.Raw = this :> IDivinable

    static member Enact<'ArgumentType> (definition : DirectiveDefinition<'ArgumentType, 'ReturnType>, argument : IDivinable<'ArgumentType>) =
        Directive<'ReturnType> (definition, argument)