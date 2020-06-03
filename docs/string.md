# `moonutil.string`
```moon
import string from require 'moonutil'
-- or
string=require 'moonutil.string'
```
Useful methodes on strings 
**`moonutil.string` is a superset of `string`** 

## `string.epat(s): string -> string`
Builds a pattern that will match literallg the given string

## `string.grep(s, a, b): string, string, string -> string`
Replaces all instances of `a` by `b` in `s`

## `string.concat(vararg<string>) -> string`
Concatenates all given strings

## `string.contains(a, b) -> boolean`
Tests if `a` contains `b`

