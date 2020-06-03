import concat from table

unpackname=if unpack then "unpack" else "table.unpack"
compile=(code) ->
	fn=(loadstring or load) code
	fn!

mktable= (d) ->
	{uv, tab}=d
	setmetatable {},
		__index: (len) =>
			v=if len<30
				uv len
			elseif len<100
				tab len
			else
				error "max 99 elements in a tuple, #{len} supplied"
			v=compile v
			rawset @, len, v
			v
mktable2= (d) ->
	{uv, tab}=d
	setmetatable {},
		__index: (i) =>
			len, idx=i\match '(%d+),(%d+)'
			len=tonumber len
			idx=tonumber idx
			v=if len<30
				uv len, idx
			elseif len<100
				tab len, idx
			else
				error "max 99 elements in a tuple, #{len} supplied"
			v=compile v
			rawset @, i, v
			v

tuplenewfn=mktable {
	(len) ->
		vars=["_#{i}" for i=1, len]
		arglist=concat vars, ','
		"return function(#{arglist}) return function() return #{arglist} end end"

	(len) ->
		"return function(...) local t={...}; return function() return #{unpackname}(t,1,#{len}) end end"
}

tuplesetfn=mktable2 {
	(len, pos) ->
		vars=["_#{i}" for i=1, len]
		arglist=concat vars, ','
		vars[pos]='_r'
		retlist=concat vars, ','
		"return function(_r,#{arglist}) return #{retlist} end"

	(len, pos) ->
		"return function(r, ...) local a={...};a[#{pos}]=r;return #{unpackname}(a,1,#{len}) end"
}

tuple={}
tuple.new= (...) ->
	tuplenewfn[select '#', ...] ...
tuple.get= (i) =>
	select i, @!
tuple.len= =>
	select '#', @!
tuple.set= (i, v) =>
	tuple.new tuplesetfn["#{select '#', @!},#{i}"] v, @!

tuple

