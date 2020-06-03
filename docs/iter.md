# `moonutil.iter`
```moon
import iter from require 'moonutil'
-- or
iter=require 'moonutil.iter'
```
Rust-like composable iterators

Iterators are kind of like a pipeline that is driven from the bottom (that is, elements are pulled from them, not pushed through them)

## Instance methods
- let `Iter<T>` be the type of any iterator that returns elements of type `T`
- let `Set<T>` be the type of a set defined in `moonutil.set`
- let `tuple<...>` be the type of a tuple defined in `moonutil.tuple`
- let `it` be an `Iter<any>`

### `it\next!: Iter<T>, nil -> T?`
Returns the next value from this iterator, or nil if none is available.
Calling `next` on an iterator that has already returned `nil` is undefined behavior.
Note that you can use `it\next` as a valid lua iterator, so you can write loops like `for v in it\next` (note the lack of `!`)

### `it\tofn!: Iter<T>, nil -> fn<nil -> T?>`
Wraps `it\next`, and can be used as a lua iterator or a generator

### `it\tolua!: Iter<T>, nil -> fn<Iter<T> -> T?>, Iter<T>`
Returns a lua iterator from the current iterator. Just returns the iterator's next method and itself

### `it\collect!: Iter<T>, nil -> arr<T>`
Collects all values from this iterator into an array table

### `it\collectkv!: Iter<{K, V}>, nil -> hash<K, V>`
Collects all values from this iterator into a dict table.
Only works on KV iterators, that is, iterators that return pairs of `{K, V}` items.
If a key is repeated, the last one is kept

### `it\collectset!: Iter<T>, nil -> Set<T>`
Collects all values from this iterator into a set.
If a value is returned multiple times, only one instance is kept

### `it\count!: Iter<any>, nil -> int`
Counts all values from this iterator

### `it\fold(f): Iter<any>, fn<any, any -> any> -> any`
Folds all values from this iterator, the same way `table.fold` works

### `it\foreach(f): Iter<T>, fn<T -> nil> -> nil`
Calls the supplied function on all values from this iterator

### `it\map(f): Iter<A>, fn<A -> B> -> Iter<B>`
Returns an iterator that maps the values that pass through it with the supplied function.
Implemented using a `MapIter`

### `it\filter(f): Iter<T>, fn<T -> boolean> -> Iter<T>`
Returns an iterator that filters the values that pass through it with the supplied prediate.
Implemented using a `FilterIter`

### `it\tee(f): Iter<T>, fn<T -> nil> -> Iter<T>`
Returns an iterator that calls the supplied function with each value that passes through it, and returns the values unmodified.
Note that this is different from calling `foreach` on an iterator, because `foreach` exhausts all values and `tee` only spies on the iterator.
Implemented using a `TeeIter`

### `it\finalize(f): Iter<T>, fn<nil -> nil> -> Iter<T>`
Returns an iterator that calls the supplied function when it no longer has any value, and returns the values unmodified.
Note that the supplied function may never be called if the last value is never reached.
Implemented using a `FinalizeIter`

### `it\skip(n): Iter<T>, int -> Iter<T>`
Returns an itetator that has the same values than the current iterator, but without the `n` first values.
The current implementation just consumes the `n` first values, discards them, and returns the iterator itself

### `it\limit(n): Iter<T>, int -> Iter<T>`
Returns an iterator that only returns `n` values before stopping.
Implemented using a `LimitIter`

### `it\loop(n): Iter<T>, int? -> Iter<T>`
Returns an iterator that has the same values than the current itetator, but repeated `n` times.
If `n` is not supplied, then the iterator will loop forever.
To achieve this, the iterator holds in memory each element that passes through it, so the longer the original iterator, the more memory will be used.
Using `loop` on an infinite iterator will consume more and more memory each time a value passes through.
Implemented using a `LoopIter`

### `it\zip(er): Iter<K>, Iter<V> -> Iter<{K, V}>`
Zips two iterators together, constructing an iterator that returns `{K, V}` pairs.
The resulting iterator will have as many items as the shortest of the two source iterators.
Implemented using a `ZipIter`

### `it\cat(er...): Iter<T>, Iter<T>... -> Iter<T>`
Concatenates multiple iterators together, constructing an iterator that returns all elements of all iterators, in order.
Implemented using a `CatIter`

## Iterator types
- `Iter!: nil -> Iter<nil>`: an iterator that returns no value, serves as the base class for all other iterators
- `MapIter(it, f): Iter<A>, fn<A -> B> -> Iter<B>`: an iterator that implements a `map` transformation
- `FilterIter(it, f): Iter<T>, fn<T -> boolean> -> Iter<T>`: an iterator that implements a `filter` transformation
- `TeeIter(it, f): Iter<T>, fn<T -> nil> -> Iter<T>`: an iterator that passes through all values and calls a function each time, see `it\tee`
- `FinalizeIter(it, f): Iter<T>, fn<nil -> nil> -> Iter<T>`: an iterator that passes through all values and calls a function when it has no more values, see `it\finalize`
- `LimitIter(it, n): Iter<T>, int -> Iter<T>`: an iterator that passes through a limited amount of values
- `LoopIter(it, n): Iter<T>, int -> Iter<T>`: an iterator that loops its values, see `it\loop`
- `ZipIter(it, er): Iter<K>, Iter<V> -> Iter<{K, V}>`: an iterator tha zips values from two iterators into `{K, V}` pairs, see `it\zip`
- `CatIter(it...): Iter<T>... -> Iter<T>`: an iterator that concatenates multiple iterators
- `ValueIter(v): T -> Iter<T>`: an iterator that returns a single value
- `RangeIter(st, ed, inc): int?, int?, int?`: an iterator that returns numbers from `st` to `ed` with an increment of `inc`
- `LuaIter(f, o, s): fn<A, B -> B>, A, B -> Iter<B>`: an iterator that returns values from a standard lua iterator (like `io.lines` or `string.gmatch`)
- `LuaKVIter(f, o, s): fn<A, B -> B, C>, A, B -> Iter<{B, C}>`: an iterator that returns values from a standard lua key-value iterator (like `pairs` or `ipairs`)
- `FnIter(f): fn<nil -> T> -> Iter<T>`: an iterator that returns values from a function
- `HashKIter(t): dict<K, any> -> Iter<K>`: an iterator that returns keys from a dict
- `HashKVIter(t): dict<K, V> -> Iter<{K, V}>`: an iterator that returns `{K, V}` pairs from a dict
- `HashVIter(t): dict<any, V> -> Iter<V>`: an iterator that returns values from a dict
- `ArrayKiter(t): arr<any> -> Iter<int>`: an iterator that returns keys from an array (same results as `RangeIter(1, #t, 1)`)
- `ArrayKVIter(t): arr<T> -> Iter<{int, T}>`: an iterator that returns `{int, T}` pairs from an array
- `ArrayVIter(t): arr<T> -> Iter<T>`: an iterator that returns values from an array
- `TupleIter(t): tuple<...> -> Iter<any>`: an iterator that returns values from a tuple

