import wrap, wrapfunc, unwrap from require 'moonutil.chainwrap'

describe 'chainwrap', ->
	describe 'wrap', ->

		it 'wraps objects and exposes _val', ->
			a = wrap 4
			assert.equal a._val, 4

			b = wrap {some: 'val', 2}
			assert.same b._val, {some: 'val', 2}

			obj = {some: 4, 'val'}
			c   = wrap obj
			assert.same c._val, obj

		it 'modifies the object when its methods are called', ->
			a = wrap 'test'
			a\upper!
			assert.equal a._val, 'TEST'

			b = wrap 's'
			b\rep 5
			assert.equal b._val, 'sssss'

		it 'can have multiple methods called and have their effects chained', ->
			a = wrap 's'
			a\rep 5
			a\upper!
			assert.equal a._val, 'SSSSS'

			b = wrap 'Bl'
			b\upper!
			b\rep 2
			assert.equal b._val, 'BLBL'

	describe 'wrapfunc', ->

		it 'wraps objects and exposes _val', ->
			a = wrapfunc 4
			assert.equal a._val, 4

			o = {some: 4, 'cal'}
			b = wrapfunc o
			assert.equal b._val, o

		it 'modifies the object when chained', ->
			a = wrapfunc {1, 2, 3}
			a\chain table.concat, 'a'
			assert.equal a._val, '1a2a3'

			b = wrapfunc 'some'
			b\chain string.upper
			assert.equal b._val, 'SOME'

		it 'can have multiple chains', ->
			a = wrapfunc {1, 2, 3}
			a\chain table.concat, 'a'
			a\chain string.upper
			assert.equal a._val, '1A2A3'

			b = wrapfunc 4
			b\chain tostring
			b\chain string.rep, 2
			b\chain tonumber
			assert.equal b._val, 44

	describe 'unwrap', ->

		it 'unwraps objects', ->
			a = unwrap {_val: 2}
			assert.equal a, 2

			o = {a: 2, 'val'}
			b = unwrap {_val: o}
			assert.equal b, o

		it 'unwraps objects wrapped by wrap', ->
			a = unwrap wrap 4
			assert.equal a, 4

			o = {a: 2, {m: 'nested'}}
			b = unwrap wrap o
			assert.equal b, o

		it 'unwraps objects wrapped by wrapfunc', ->
			a = unwrap wrapfunc 4
			assert.equal a, 4

			o = {a: 2, {m: 'nested'}}
			b = unwrap wrapfunc o
			assert.equal b, o

