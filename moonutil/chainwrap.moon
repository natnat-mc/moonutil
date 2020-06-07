wrap = =>
	setmetatable {_val: @},
		__index: (k) =>
			(_, ...) ->
				@_val = @_val[k] @_val, ...

wrapfunc = =>
	{
		_val: @
		chain: (fn, ...) =>
			@_val = fn @_val, ...
	}

unwrap = =>
	@_val

{
	:wrap, :wrapfunc
	:unwrap
}

