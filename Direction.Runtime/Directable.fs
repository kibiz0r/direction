﻿namespace Direction.Dsl

open System

module Directable =
    let ignore (directable : IDirectable<'T>) : IDirectable<unit> =
        obj () :?> IDirectable<unit>