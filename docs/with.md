# `moonutil.with`
```moon
import mwith from require 'moonutil'
-- or
mwith = require 'moonutil.with'
```
Utilities to recreate Python's `with` statement and some tools from `contextlib`

## `use(k: v..., fn): string: Context<T>, fn<dict<string, T> -> V> -> V` OR `use(c..., fn): Context<T>..., fn<Context<T>... -> V> -> V`
Basically the same as the `with` statement from Python.

This function does, in this order:
	- resolve the contexts to their keys, and finds out if the first or second form is in use
	- calls `__begin` on every context with the context as only argument
	- if any context throws, the function call is skipped
	- calls `__val` on every context to get its value
	- if any value throws, the function call is skipped
	- calls the function with either the dict of values or an argument list of values
	- if the function returns values, store them, and same with exceptions
	- call `__end` on every context with the context as first argument (and the exception as second argument if there was one)
	- if any context returns `true`, flag the value as suppressed
	- if the value was suppressed, `use` returns nothing
	- if there was an error, `use` re-throws it
	- otherwise, `use` returns the same value as the function

## `class Context`
A class that can be used to easily create contexts, by default does nothing on `__begin`, returns `nil` and doesn't suppress errors

## `nullcontext(val): any -> Context<any>`
Wraps a value in a context, so that it can later be used in `use`.
Useless by itself, but can be used as an alternate value (either `open(file)` or `nullcontext(io.stdin)` for example)

## `open(file, mode): string, string? -> Context<file>`
Wraps a file in a context, and throws if the file cannot be opened

## `popen(cmd, mode): string, string? -> Context<file>`
Same as `open`, but uses `popen` instead

## `finalize(): nil -> Context<fn<fn<nil -> nil> -> nil>`
Creates a context that stores a stack of functions to call when the context is exited, and returns a function that puhes a function onto that stack

## `time(): nil -> Context<nil>`
Creates a context that does nothing, but times the `use` block with a second resolution

## `suppress(): nil -> Context<nil>`
Creates a context that does nothing, but suppresses errors.
If that's the only context you're using, you should probably just use `pcall`

