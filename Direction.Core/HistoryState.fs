namespace Direction.Core

open System

type HistoryState = {
    Head : RevisionId
    RevisionGraph : RevisionGraph
}
