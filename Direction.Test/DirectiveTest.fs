namespace Direction.Test

open System
open NUnit.Framework
open FsUnit
open Direction
open Divination

[<TestFixture>]
module DirectiveTest =
    [<Test>]
    let ``Directives do stuff`` () =
        let diviner = TimeframeDiviner ()
        let timeframeDiviningContext = TimeframeDiviningContext ()
        let divinableMethod : IDivinable<bool -> int> = obj () :?> IDivinable<bool -> int>
        let directiveDefinition = DirectiveDefinition (divinableMethod)
        let directiveArgument : IDivinable<bool> = obj () :?> IDivinable<bool>
        let directive = Directive<int> (directiveDefinition, directiveArgument)
        let directiveValue = Divinable.divine diviner timeframeDiviningContext directive
        directiveValue.Value
