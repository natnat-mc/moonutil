import sort from table

clone= (e) -> {k, v for k, v in pairs e}
table=clone table
table.clone=clone

table.keys= (t) ->
	[k for k in pairs t]

table.pairs= (t) ->
	[{k, v} for k, v in pairs t]

table.fold= (fn) =>
	v=@[1]
	for i=2, #@
		v=fn @[i], v
	v
table.foldl=table.fold

table.foldr= (fn) =>
	l=#@
	v=@[l]
	for i=l-1, 1, -1
		v=fn @[i], v
	v

table.map= (fn) =>
	[fn v for v in *@]

table.filter= (fn) =>
	[v for v in *@ when fn v]

table.find= (fn) =>
	for v in *@
		return v if fn v
table.findl=table.find

table.findr= (fn) =>
	l=#@
	for i=l, 1, -1
		v=@[i]
		return v if fn v

table.contains= (e) =>
	for v in *@
		return true if v==e
	false

table.index= (e) =>
	for i=1, #@
		v=@[i]
		return i if v==e
table.indexl=table.index

table.indexr= (e) =>
	l=#@
	for i=l, 1, -1
		v=@[i]
		return i if v==e

table.foreach= (fn) =>
	for v in *@
		fn v
table.foreachl=table.foreach

table.foreachr= (fn) =>
	l=#@
	for i=l, 1, -1
		fn @[i]

table.slice= (s=1, e=#@) =>
	[@[i] for i=s, e]

table.sort= (...) =>
	sort @, ...
	@

table.cross= (o) =>
	a, i={}, 1
	for v in *@
		for u in *o
			a[i], i={v, u}, i+1
	a

table.lazyclone= (t) ->
	setmetatable {},
		__index: (k) =>
			v=t[k]
			rawset @, k, v
			v

table.lazyfn= (t) ->
	setmetatable {},
		__index: (k) =>
			f=t[k]
			return nil unless f
			v=f!
			rawset @, k, v
			v

table.lazyload= (f) ->
	local t
	setmetatable {},
		__index: (k) =>
			t=f! unless t
			v=t[k]
			rawset @, k, v
			v

table

