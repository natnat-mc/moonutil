# `moonutil.set`
```moon
import Set from require 'moonutil'
-- or
Set=require 'moonutil.set'
```
Finite sets

- let `Set<T>` be the type of a set of `T` elements
- let `Iter<T>` be the type of an iterator defined in `moonutil.iter` 
- let `s` be a `Set<any>`

## `Set!: nil -> Set<any>`
Builds a new set ready to accept items

## `Set(t): arr<T> -> Set<T>`
Builds a set and immediately add items to it from an array table.
Any duplicate value is discarded

## `s\set(e): Set<T>, T -> nil`
Adds a value to the set if it isn't already present

## `s\unset(e): Set<T>, T -> nil`
Removes a value from the set if it was present

## `s\has(e): Set<T>, T -> boolean`
Tests for the existence of an element in the set

## `s\len!: Set<any> -> int`
Returns the number of elements in the set

## `s\iter!: Set<T> -> Iter<T>`
Returns an iterator on the set

## `s\intersect(t): Set<T>, Set<T> -> Set<T>`
Returns a set containing all elements that are present in both sets

## `s\union(t): Set<A>, Set<B> -> Set<A|B>`
Returns a set containing all elements that are present in at least one set

## `s\difference(t): Set<A>, Set<B> -> Set<A|B>`
Returns a set containing all elements that are pesent in exactly one set

## `s\subtract(t): Set<T>, Set<T> -> Set<T>`
Returns a set containing all elements that are in the first set but not the second

