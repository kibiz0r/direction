namespace Direction.Data

open System
open System.Reflection
open FSharp.Quotations
open FSharp.Quotations.Patterns

type MethodInfoData = {
    DeclaringType : string
    Name : string
}

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module MethodInfoData =
    let fromMethodInfo (methodInfo : MethodInfo) : MethodInfoData =
        {
            DeclaringType = methodInfo.DeclaringType.AssemblyQualifiedName
            Name = methodInfo.Name
        }

    let toMethodInfo (methodInfoData : MethodInfoData) : MethodInfo =
        let type' = Type.GetType methodInfoData.DeclaringType
        type'.GetMethod methodInfoData.Name

    let fromExpr (expr : Expr) : MethodInfoData =
        let methodInfo =
            match expr with
            | Call (_, methodInfo, _) -> methodInfo
            | _ -> invalidOp ""
        fromMethodInfo methodInfo