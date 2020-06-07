import match from string

allowescape =
	__index: (k) =>
		k = match k, '^_*(.-)_*$'
		rawget @, k
	__newindex: (k, v) =>
		k = match k, '^_*(.-)_*$'
		rawset @, k, v

func     = setmetatable {}, allowescape
func.val = (v) -> -> v
func.is  = (v) -> (a) -> a==v

func.bind  = (v) => (...) -> @ v, ...
func.bind2 = (v) => (a, ...) -> @ a, v, ...

func.restrict = (n) => (...) ->
	c = select '#', ...
	@ unpack {...}, 1, math.min c, n

func._then = (f) => (...) -> f @ ...
func.chain = (fn, ...) ->
	for i=1, select '#', ...
		fn = func.then fn, select i, ...
	fn

func.tee = (fn) -> (...) ->
	fn ...
	...

func.combine = (a, b, op) -> (...) ->
	va = a ...
	vb = b ...
	op va, vb

func._and = (a, b) -> (...) ->
	va = a ...
	va and b ...
func._or  = (a, b) -> (...) ->
	va = a ...
	va or b ...
func._not = (f) -> (...) -> not f ...
func._if  = (c, t, f) -> (...) ->
	return if c ...
		t ...
	else
		f ...

func.op =
	identity: (...)  -> ...
	eq:       (a, b) -> a==b
	neq:      (a, b) -> a!=b
	lt:       (a, b) -> a<b
	le:       (a, b) -> a<=b
	gt:       (a, b) -> a>b
	ge:       (a, b) -> a>=b
	add:      (a, b) -> a+b
	sub:      (a, b) -> a-b
	mul:      (a, b) -> a*b
	div:      (a, b) -> a/b
	mod:      (a, b) -> a%b
	pow:      (a, b) -> a^b
	concat:   (a, b) -> a..b
	and:      (a, b) -> a and b
	or:       (a, b) -> a or b
	unm:      (a)    -> -a
	len:      (a)    -> #a
	not:      (a)    -> not a
	inspect:  (...)  ->
		print ...
		...
setmetatable func.op, allowescape

func.t = setmetatable {}
	__index: (k) =>
		fn = func[k]
		fn and (f, ...) ->
			if (type f)=='table'
				return fn unpack f
			fn f, ...

func

