# Direction

Direction is a language extension for Ruby, that allows you to keep a history of state changes on your objects, identified by method invocations and variable assignments; this gives you the ability to modify, rewind, and replay the history of an object, and opens the door to using CQRS, EventStores, Aspect-Oriented Programming, and other paradigms, with a consistent interface alongside normal Ruby.

## Overview

In Direction, there are four fundamental concepts:

 * History: Mutable record of an object's previous states
 * Change: An immutable value object representing a state change, 
 * Directive: A facade for managing a history with respect to a method invocation
 * Delta: A facade for managing a history with respect to a variable assignment

### Histories

Direction extends Object with a `#history` method, which returns a History. Histories are the fundamental interface to an object's current state.

#### Getting a List of Changes



#### Adding a Change

A Change (either a Directive, a Delta, or a custom Change) is simply a 

### Directives