namespace Direction.Runtime

open System
open FSharp.Quotations
open Direction.Core

// A Change contains a Definition, which is assumed to be in a form that can
// be evaluated by some Director at a later time, as well as a Timeframe
// which contains all of the prerequisites needed to evaluate the Definition
// (as well as providing the necessary state information for subsequent
// Definitions to be evaluated)
type Change = {
    Definition : ChangeDefinition
    Timeframe : Timeframe
}