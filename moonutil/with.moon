unpack or= table.unpack

use = (...) ->
	argv = (select '#', ...)-1
	fn = select argv+1, ...

	contexts = {}
	tablemode = false
	maxi = 0
	loadctx = (ctx, i) ->
		if not ctx.__begin
			tablemode = true
			loadctx v, k for k, v in pairs ctx
			return
		maxi = i
		contexts[i] = ctx
	for i=1, argv
		loadctx (select i, ...), i

	err, threw, suppressed = nil, false, false
	handleexception = (fn, main) ->
		imp = (ok, ...) ->
			if ok
				return (select '#', ...), {...}
			elseif main
				err = (...)
				threw = true
		imp pcall fn

	bound = ->
		values = {k, v\__val! for k, v in pairs contexts}
		if tablemode
			fn values
		else
			fn unpack values, 1, maxi

	n, retval = 0, {}
	for _, ctx in pairs contexts
		handleexception ctx\__begin, false
	unless threw
		n, retval = handleexception bound, true
	for _, ctx in pairs contexts
		ok, suppress = pcall -> ctx\__end err
		suppressed = true if ok and suppress==true

	return if suppressed
	error err if threw
	return unpack retval, 1, n

class Context
	__begin: ->
	__val:   -> nil
	__end:   -> false

class nullcontext extends Context
	new: (@val) =>
	__val: => @val

class open extends Context
	new: (@file, @mode) =>

	__begin: =>
		@fd, err = io.open @file, @mode
		error err unless @fd

	__val: => @fd

	__end: => fd\close! and nil

class popen extends open
	__begin: =>
		@fd, err = io.popen @file, @mode
		error err unless @fd

class finalize extends Context
	new: =>
		@stack = {}

	__val: =>
		(fn_or_tab, nil_or_fn) ->
			fn = nil_or_fn or fn_or_tab
			error "finalize takes function arguments, given #{fn} (#{type fn})" unless 'function'==type fn
			table.insert @stack, fn
	
	__end: =>
		for i=#@stack, 1, -1
			pcall stack[i]
		nil

class time extends Context
	__begin: =>
		@begintime = os.time!
	
	__end: =>
		endtime = os.time!
		totaltime = endtime-@begintime
		print "took #{totaltime}s"
		nil

class suppress extends Context
	__end: => true

{
	:use
	:Context
	:nullcontext
	:open, :popen
	:finalize
	:time
	:suppress
}

