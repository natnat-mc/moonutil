Set = require 'moonutil.set'

local Iter
local collect,    collectkv,   collectset
local count,      fold,        foreach
local MapIter,    FilterIter,  TeeIter, FinalizeIter
local LimitIter,  LoopIter
local ZipIter,    CatIter
local ValueIter,  RangeIter
local LuaIter,    LuaKVIter,   FnIter
local HashKIter,  HashKVIter,  HashVIter
local ArrayKIter, ArrayKVIter, ArrayVIter
local TupleIter

-- base iterator class
class Iter
	new:  () =>
	next: => nil

	tofn:  => @\next
	tolua: => @.next, @

	__tostring: =>
		@@__name

	-- collect all the values into a table
	collect: => collect @

	-- collect all the kv values into a hash
	collectkv: => collectkv @

	-- collect values into a set
	colllectset: => collectset @

	-- count the number of values
	count: => count @

	-- fold the values with a function
	fold: (fn) => fold @, fn

	-- exhaust the iterator and give all values to a function
	foreach: (fn= ->) => foreach @, fn

	-- map the values through a function
	map: (fn) =>
		MapIter @, fn

	-- filter the values by a function
	filter: (fn) =>
		FilterIter @, fn

	-- call a function for each value that passes
	-- note that this doesn't consume values
	tee: (fn) =>
		TeeIter @, fn

	-- call a function on iterator end
	finalize: (fn) =>
		FinalizeIter @, fn

	-- skip n values
	skip: (n=1) =>
		for i=1, n
			@next!
		@

	-- limit to n values
	limit: (n=1) =>
		LimitIter @, n

	-- loop the iterator n times
	loop: (n=math.huge) =>
		LoopIter @, n

	-- zip with another iterator
	zip: (it) =>
		ZipIter @, it

	-- concatenate with anothee iterator
	cat: (...) =>
		CatIter @, ...

collect = =>
	a, i = {}, 1
	while true
		v = @next!
		if v!=nil
			a[i], i = v, i+1
		else
			return a

collectkv = =>
	a = {}
	while true
		v = @next!
		if v!=nil
			a[v[1]] = a[v[2]]
		else
			return a

collectset = =>
	s = Set!
	while true
		v = @next!
		if v!=nil
			s\set v
		else
			return s

count = =>
	n = 0
	while @next! !=nil
		n += 1
	n

fold = (fn) =>
	a = @next!
	while true
		v = @next!
		if v!=nil
			a = fn a, v
		else
			return a

foreach = (fn) =>
	while true
		v = @next!
		if v!=nil
			fn v
		else
			return

-- derived iterator: map
class MapIter extends Iter
	new:  (@it, @fn) =>
	next: =>
		val = @it\next!
		if val!=nil
			@.fn val
		else
			nil

-- derived iterator: filter
class FilterIter extends Iter
	new:  (@it, @fn) =>
	next: =>
		v = @it\next!
		return nil if v==nil
		if @.fn v
			v
		else
			@next!

-- derived iterator: tee
class TeeIter extends Iter
	new:  (@it, @fn) =>
	next: =>
		v = @it\next!
		return nil if v==nil
		@.fn v
		v

-- derived iterator: finalize
class FinalizeIter extends Iter
	new:  (@it, @fn) =>
	next: =>
		v = @it\next!
		@.fn! if v==nil
		v

-- derived iterator: limit
class LimitIter extends Iter
	new:  (@it, @n=1) =>
	next: =>
		@n -= 1
		if @n>=0
			@it\next!
		else
			nil

-- derived iterator: loop
class LoopIter extends Iter
	new:  (@it, @n=math.huge) =>
		@a = {}
		@i = 1
		@l = 1
	next: =>
		if @l>@n
			nil
		elseif @l>1
			v = @a[@i]
			if v!=nil
				@i += 1
				v
			else
				@l += 1
				@i  = 1
				@next!
		else
			v = @it\next!
			if v!=nil
				@a[@i]  = v
				@i     += 1
				v
			else
				@l += 1
				@i  = 1
				@next!

-- derived iterator: zip
class ZipIter extends Iter
	new:  (@a, @b) =>
	next: =>
		a = @a\next!
		return nil if a==nil
		b = @b\next!
		if b!=nil
			{a, b}
		else
			nil

-- derived iterator: cat
class CatIter extends Iter
	new:  (...) =>
		@iters = {...}
		@it    = table.remove @iters, 1
	next: =>
		if @it
			v = @it\next!
			if v!=nil
				v
			else
				@it = table.remove @iters, 1
				@next!
		else
			nil

-- specializes iterator: single value
class ValueIter extends Iter
	new:  (@val) =>
	next: =>
		v    = @val
		@val = nil
		v

-- specialized iterator: range
class RangeIter extends Iter
	new:  (@st=1, @ed=math.huge, @inc=1) =>
		@state=st-@inc
	next: =>
		@state += @inc
		if @inc>0 and @state>@ed
			@state = nil
		if @inc<0 and @state<@ed
			@state = nil
		@state

-- specialized iterator: lua single value
class LuaIter extends Iter
	new:  (@it, @obj, @st) =>
	next: =>
		@st = @.it @obj, @st
		@st

-- specialized iterator: lua bi-value
class LuaKVIter extends Iter
	new:  (@it, @obj, @st) =>
	next: =>
		@st, v = @.it @obj, @st
		{@st, v}

-- specialized iterator: function
class FnIter extends Iter
	new:  (@fn) =>
	next: =>
		@.fn!

-- specialized iterator: hash keys
class HashKIter extends Iter
	new:  (@obj) =>
		@state = nil
	next: =>
		@state = next @obj @state
		@state

-- specialized iterator: hash kv
class HashKVIter extends Iter
	new:  (@obj) =>
		@state = nil
	next: =>
		@state, val = next @obj, @state
		if @state
			{@state, val}
		else
			nil

-- specialized iterator: hash values
class HashVIter extends Iter
	new:  (@obj) =>
		@state = nil
	next: =>
		@state, val = next @obj, @state
		if @state
			val
		else
			nil

-- specialized iterator: array keys
class ArrayKIter extends RangeIter
	new: (obj) =>
		super 1, #obj

-- specialized iterator: array kv
class ArrayKVIter extends Iter
	new:  (@obj) =>
		@k = 1
	next: =>
		k   = @k
		v   = @obj[k]
		@k += 1
		if v!=nil
			{k, v}
		else
			nil

-- specialized iterator: array values
class ArrayVIter extends Iter
	new:  (@obj) =>
		@k = 1
	next: =>
		v   = @obj[@k]
		@k += 1
		v

-- specialized iterator: tuple
class TupleIter extends Iter
	new:  (@tup) =>
		@k  = 1
		@l  = select '#', tup!
	next:  =>
		return nil if @k>@l
		v   = select @k, @.tup!
		@k += 1
		v

{
	next: => @next!
	tofn: => @tofn!
	tolua: => @tolua!
	:collect,         :collectkv,         :collectset
	:count,           :fold,              :foreach
	map: MapIter,     filter: FilterIter, tee: TeeIter, finalize: FilterIter
	limit: LimitIter, loop: LoopIter
	zip: ZipIter,     cat: CatIter
	value: ValueIter, range: RangeIter

	:Iter
	:MapIter,    :FilterIter,  :TeeIter, :FinalizeIter
	:LimitIter,  :LoopIter
	:ZipIter,    :CatIter
	:ValueIter,  :RangeIter
	:LuaIter,    :LuaKVIter,   :FnIter
	:HashKIter,  :HashKVIter,  :HashVIter
	:ArrayKIter, :ArrayKVIter, :ArrayVIter
	:TupleIter
}

