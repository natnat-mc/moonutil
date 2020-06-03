# `moonutil.table`
```moon
import table from require 'moonutil'
-- or
table=require 'moonutil.table'
```
Useful methodes on tables  
**`moonutil.table` is a superset of `table`**  
*all functions marked with \* have variants with a `l` prefix that start from the left anf a `r` prefix that starts from the right*

## `table.clone(t): table -> table`
Clones a table, identical to `{k, v for k, v in pairs t}`

## `table.keys(t): dict<K, V> -> arr<V>`
Returns an array table of all the keys of `t`

## `table.pairs(t): dict<K, V> -> arr<{K, V}>`
Returns an array table of all key-value pairs of `t`

## `table.fold(t, f): arr<any>, fn<any, any -> any> -> any`\*
Folds an array table by repetitively calling `f` on an accumulator and the next value of `t`

## `table.map(t, f): arr<A>, fn<A -> B> -> arr<B>`
Maps an array table by a function

## `table.filter(t, f): arr<A>, fn<A -> boolean> -> arr<A>`
Filters an array with a given predicate

## `table.find(t, f): arr<A>, fn<A -> boolean> -> A`\*
Finds the first value of an array table that matches the given predicate

## `table.contains(t, v): arr<any>, any -> boolean`
Checks if an array table contains a given value

## `table.index(t, v): arr<any>, any -> int`\*
Finds the first occurence of a given value in an array table

## `table.foreach(t, f): arr<A>, fn<A -> nil> -> nil`\*
Calls a function for each value of an array table

## `table.slice(t, a, b): arr<A>, int, int -> arr<A>`\*
Slices an array table between two indices

## `table.sort(t, f): arr<A>, fn<A, A -> boolean>? -> arr<A>`
Sorts an array table (mutates the array table)

## `table.cross(a, b): arr<A>, arr<B> -> arr<{A, B}>`
Returns the cartesian product of two array tables

## `table.lazyclone(t): dict<K, V> -> lazytable<K, V>`
Returns a table that lazily loads its values from the given table

## `table.lazyfn(t): dict<K, fn<nil -> V>> -> lazytable<K, V>`
Returns a table that lazily loads its values from the value returned by the corresponding keys of the given table

## `table.lazyload(f): fn<nil -> dict<K, V>> -> lazytable<K, V>`
Returns a table that lazily loads its values from the values of the table returned by the given function

