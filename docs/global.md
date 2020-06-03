# `moonutil.global`
```moon
require 'moonutil.global'
```
***Be very sure that this is what you want, as it breaks quite a lot of stuff, including moonscript and lpeg***

Loads `table`, `string`, `tuple`, `func`, `set` and all iterator classes as globals, and override the `string` and `function` metatables

- `fn[k]` -> `func[k]`, which means you can call methods on functions
- `fn % v` -> `func.bind(fn, v)`
- `fn / v` -> `func.bind2(fn, v)`
- `fn ^ v` -> `func.then(fn, v)`
- `fn - v` -> `func.restrict(fn, v)`
- `fn + v` -> `func.or(fn, v)`
- `fn * v` -> `func.and(fn, v)`
- `-fn` -> `func.not(fn)`

- `str[k]` -> `string`
- `str[i]` -> `string.sub(str, i, i)`
- `str % {...}` -> `string.format(str, ...)`
- `str - v` -> `string.gsub(str, string.epat(v), '')`, which essentially removes every insance of `v` from `str`
- `str / v` -> `string.gmatch(str, v)`
- `str + v` -> `string.contains(str, v)`
- `str * v` -> `string.rep(str, v)`

