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

## `string.concat(a...): string... -> string`
Concatenates all given strings

## `string.contains(a, b): string, string -> boolean`
Tests if `a` contains `b`

## `string.split(s, pat, n): string, string, number? -> arr<string>, int`
Splits `s` on the pattern `pat` (that must not contain any capture), applied at most `n` timed

