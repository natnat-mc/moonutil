# `moonutil.function`
```moon
import func from require 'moonutil'
-- or
func=require 'moonutil'
```
Useful methods on functions. Yes, you read that right  
*everything in `func`, `func.op` and `func.t` can be accessed with any number of `_` before or after the canonical name*

## `func.val(v): T -> nil -> T`
Returns a function that always returns the supplied value

## `func.is(v): T -> any -> boolean`
Returns a function that returns whether or not its argument is the supplied value

## `func.bind(f, v): fn<any... -> any...>, T -> any... -> any...`
Returns a function that is the same as the supplied function, but with the supplied value as first argument

## `func.bind2(f, v): fn<any... -> any...>, T -> any... -> any...`
Same as `bind`, but injects the value as second argument instead

## `func.restrict(f, n): fn<any... -> any...>, int -> any... -> any...`
Returns a function that is the same as the supplied function, but with at most `n` arguments

## `func.then(f, t): fn<A... -> B...>, fn<B... -> C...> -> A... -> C...`
Returns a function that is the same as `f` then `t`, essentially, this is `t(f(x))` for any `x`, but with any number of arguments and return values

## `func.chain(f...): fn<any... -> any...>... -> any... -> any...`
Essentially the same as `then`, but with as many functions as you want

## `func.tee(f, t): fn<A... -> B...>, fn<A... -> nil> -> A... -> B...`
Returns a function that calls `t`, discards the results and then returns the results of `f`

## `func.combine(a, b, op): fn<A... -> B>, fn<A... -> C>, fn<B, C -> D...> -> A... -> D...`
Returns a function that is the result of `op` given the results of both `a` and `b`

## `func.and(a, b): fn<A... -> B>, fn<A... -> C...> -> A... -> B|C...`
Returns the first result of `a` if it is falsy (`nil` or `false`) or all of the results of `b`

## `func.or(a, b): fn<A... -> B>, fn<A... -> C...> -> A... -> B|C...`
Returns the first result of `a` if it is truthy (neither `nil` nor `false`) or all of the results of `b`

## `func.not(a): fn<A... -> boolean> -> A... -> boolean`
Returns the negation of `a`

## `func.if(a, b, c): fn<A... -> boolean>, fn<A... -> B...>, fn<A... -> C...> -> A... -> B...|C...`
Returns a function that is the results of `b` if `a` returns a truthy value, and the results of `c` otherwise

## `func.op.identity: A... -> A...`
Returns its arguments unchanged

## `func.op.eq: any, any -> boolean`
Returns whether or not its arguments are equal

## `func.op.neq: any, any -> boolean`
Returns whether or not its arguments are inequal

## `func.op.lt: any, any -> boolean`
Returns whether or not its first argument is less than its second

## `func.op.le: any, any -> boolean`
Returns whether or not its first argument is less than or equal to its second

## `func.op.gt: any, any -> boolean`
Returns whether or not its first argument is greater than its second

## `func.op.ge: any, any -> boolean`
Returns whether or not its first argument is greater than or equal to its second

## `func.op.add, func.op.sub, func.op.mul, func.op.div, func.op.mod, func.op.concat: any, any -> any`
Return the value returned by the corresponding operator (`+`, `-`, `*`, `/`, `%` and `..` respectively)

## `func.op.inspect: A... -> A...`
The same as the identity function, except it also `print`s all values it gets

## `func.t.*`
The same as `func.*`, except that if the first argument is a table, it is expanded and that becomes the argument list

