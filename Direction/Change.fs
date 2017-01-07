namespace Direction

open System
open System.Reflection
open FSharp.Quotations

type Change = {
    Definition : MemberInfo
    Arguments : Expr list
}
