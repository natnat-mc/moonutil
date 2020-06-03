# `moonutil.tuple`
```moon
import tuple from require 'moonutil'
-- or
tuple=require 'moonutil.tuple'
```
Immutable tuples backed by functions

## `tuple.new(a): any... -> tuple<any...>`
Builds a tuple containing all values supplied (to a maximum of 99 using tables and 29 using upvalues)

## `tuple.get(t, i): tuple<any...>, int -> any`
Returns the value at the given index in the tuple

## `tuple.set(t, i, v): tuple<any...>, int, any -> tuple<any...>`
Returns a new tuple that is similar to the original one, but with the given value changed

## `tuple.len(t): tuple<any...> -> int`
Returns the number of elements in the tuple

## `t!: tuple<any...> -> any...`
Returns all the values from the tuple directly

