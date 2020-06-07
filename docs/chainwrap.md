# `moonutil.chainwrap`
```moon
import chain from require 'moonutil'
-- or
chain = require 'moonutil.chainwrap'
```
Functions to abuse the `with` statement for functional programming and/or OOP call chains

## `wrap(obj): Object -> Proxy<Object>`
Wraps an object so that calling its methods will instead mutate the object with their return value

```moon
with wrap ArrayVIter {1, 2, 3, 4, -1}
	\map => 2*@
	\filter @>2
	\foreach print
-- behaves like
_tmp = ArrayVIter {1, 2, 3, 4, -1}
_tmp = _tmp\map => 2*@
_tmp = _tmp\filter => @>2
_tmp = _tmp\foreach print
```

## `wrapfunc(obj): any -> Proxy<any>`
Wraps an object so that calling the `chain` method on it will istead mutate it according to the given function and arguments

```moon
with wrapfunc {1, 2, 3, 4, -1}
	\chain table.map, => 2*@
	\chain table.filter, => @>2
	\chain table.foreach, print
-- behaves like
_tmp = {1, 2, 3, 4, -1}
_tmp = table.map _tmp, => 2*@
_tmp = table.filter _tmp, => @>2
_tmp = table.foreach _tmp, print
```

## `unwrap(obj): Proxy<T> -> T`
Unwraps a proxy created by `wrap` or `wrapfunc` so that the resulting object can immediately be used.  
Its implementation is just `=> @_val`, but having the function is convenient and allows for one-line wrap and unwrap

```moon
a = unwrap with wrapfunc {1, 2, 3, 4, -1}
	\chain table.map, => 2*@
	\chain table.filter, => @>2
-- a is now {4, 6, 8}
```

