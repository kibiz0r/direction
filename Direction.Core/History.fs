namespace Direction.Core

open System

// A History is a persistable record of change and effect definitions that
// can be replayed and turned into a Timeline when given a Director
// Note that a Director may not agree with the Ids of the Definitions...
// So it may be preferable to store a History as a Set of Definitions,
// or even as a graph of Definitions without mentioning Ids, or as
// serialized results... There are many options, which is why it's good
// to not couple anything to a specific History format if avoidable.
type History = {
    ChangeDefinitions : Map<ChangeId, ChangeDefinition>
    EffectDefinitions : Map<EffectId, EffectDefinition>
}

[<CompilationRepresentation (CompilationRepresentationFlags.ModuleSuffix)>]
module History =
    let empty =
        { ChangeDefinitions = Map.empty; EffectDefinitions = Map.empty }

    //let change changeDefinition history =
    //    let changeId = ChangeDefinition.id changeDefinition
    //    { ChangeDefinitions = Map.add changeId changeDefinition history.ChangeDefinitions }

    let changeDefinition changeId history =
        history.ChangeDefinitions.[changeId]