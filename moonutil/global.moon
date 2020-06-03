import table, string, func, iter, tuple, Set from require 'moonutil'

_G.table=table
_G.string=string
_G.func=func
_G.tuple=tuple
_G.Set=Set
_G[k]=v for k, v in pairs iter

error "need debug to alter function metatable" unless debug and debug.setmetatable

functionmeta={}
debug.setmetatable (->), functionmeta

functionmeta.__index=func
functionmeta.__mod=func.bind
functionmeta.__div=func.bind2
functionmeta.__pow=func.then
functionmeta.__sub=func.restrict
functionmeta.__add=func.or
functionmeta.__mul=func.and
functionmeta.__unm=func.not

_G.string=string
import sub, epat from string
stringmeta=getmetatable ''
stringmeta.__index= (i) =>
	if (type i)=='number'
		return sub @, i, i
	rawget string, i
stringmeta.__mod= (fmt) => string.format @, unpack fmt
stringmeta.__sub= (rem) => string.gsub @, (epat rem), ''
stringmeta.__div=string.gmatch
stringmeta.__add=string.contains
stringmeta.__mul=string.rep

