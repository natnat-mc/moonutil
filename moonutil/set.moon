import lazyload from require 'moonutil.table'
iter=lazyload -> require 'moonutil.iter'
import concat from table

class Set
	new: (tab) =>
		@back={}
		if tab
			@back[k]=true for k in *tab

	has: (k) => @back[k] or false
	set: (k) => @back[k]=true
	unset: (k) => @back[k]=nil

	__tostring: =>
		"Set(#{concat [tostring k for k in pairs @back], ', '})"

	len: =>
		l=0
		l+=1 for k in pairs @back
		l
	__len: => @len!

	iter: => iter.HashKIter @back

	intersect: (o) =>
		s=Set!
		for k in pairs @back
			s.back[k]=true if o.back[k]
		s
	__mul: (o) => @intersect o
	union: (o) =>
		s=Set!
		s.back[k]=true for k in pairs @back
		s.back[k]=true for k in pairs o.back
		s
	__add: (o) => @union o
	difference: (o) =>
		s=Set!
		for k in pairs @back
			s.back[k]=true unless o.back[k]
		for k in pairs o.back
			s.back[k]=true unless @back[k]
		s
	__div: (o) => @difference o
	subtract: (o) =>
		s=Set!
		for k in pairs @back
			s.back[k]=true unless o.back[k]
		s
	__sub: (o) => @subtract o

