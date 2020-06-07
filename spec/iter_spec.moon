iter = require 'moonutil.iter'

say = require 'say'
import same from require 'luassert.match'

returnsit = (args) =>
	local iter, values
	iter = args[1]
	values = args[2]
	for v in *values
		n = iter\next!
		return false unless same v, n
	return false unless nil==iter\next!
	return true

say\set("assertion.returnsit.positive", -> "Expected %s \nto return values: %s")
assert\register("assertion", "returnsit", returnsit, "assertion.returnsit.positive")

describe 'iter', ->

	describe 'ValueIter', ->
		import ValueIter, value from iter

		it 'assert.returnsit a single value', ->
			a = ValueIter 4
			assert.returnsit a, {4}

			b = ValueIter false
			assert.returnsit b, {false}

			c = value 4
			assert.returnsit c, {4}

		it 'assert.returnsit nothing if given nil', ->
			a = ValueIter nil
			assert.equal nil, a\next!

			b = value nil
			assert.equal nil, b\next!

	describe 'RangeIter', ->
		import RangeIter from iter

		it 'works with increasing ranges', ->
			a = RangeIter 1, 5, 1
			assert.returnsit a, {1, 2, 3, 4, 5}

			b = RangeIter!
			for i=1, 10
				assert.equal i, b\next!
			assert.not.equal nil, b\next!

			c = RangeIter 5, 10
			assert.returnsit c, {5, 6, 7, 8, 9, 10}

			d = RangeIter 4, 12, 2
			assert.returnsit d, {4, 6, 8, 10, 12}

		it 'works with decreasing ranges', ->
			a = RangeIter 5, 1, -1
			assert.returnsit a, {5, 4, 3, 2, 1}

			b = RangeIter 10, 6, -3
			for i=10, 6, -3
				assert.equal i, b\next!
			assert.equal nil, b\next!

	describe 'LuaIter', ->
		import LuaIter from iter

		it 'works', ->
			a = LuaIter pairs {a: 1}
			assert.returnsit a, {'a'}

			b = LuaIter ipairs {1, 2, 4, 3}
			assert.returnsit b, {1, 2, 3, 4}

			c = LuaIter pairs {}
			assert.equal nil, c\next!

	describe 'LuaKVIter', ->
		import LuaKVIter from iter

		it 'works', ->
			a = LuaKVIter ipairs {'a', 'b', 'c'}
			assert.returnsit a, {{1, 'a'}, {2, 'b'}, {3, 'c'}}

			b = LuaKVIter pairs {a: 1}
			assert.returnsit b, {{'a', 1}}

			c = LuaKVIter ipairs {}
			assert.equal nil, c\next!

	describe 'FnIter', ->
		import FnIter from iter

		it 'works', ->
			always4 = -> 4
			onetofour = do
				i = 1
				->
					v = i
					i += 1
					return nil if v>4
					v

			a = FnIter always4
			for i=1, 10
				assert.equal 4, a\next!

			b = FnIter onetofour
			assert.returnsit b, {1, 2, 3, 4}

	describe 'HashKIter', ->
		import HashKIter from iter

		it 'works', ->
			tab = {a: 1, b: 2, c: 3, d: 4}
			keys = {'a', 'b', 'c', 'd'}

			a = HashKIter tab
			ta = {}
			for i=1, 4
				ta[i] = a\next!
			table.sort ta
			assert.same ta, keys
			assert.equal nil, a\next!

	describe 'HashKVIter', ->
		import HashKVIter from iter

		it 'works', ->
			tab = {a: 1, b: 2, c: 3, d: 4}
			
			a = HashKVIter tab
			ta = {}
			for i=1, 4
				{k, v} = a\next!
				ta[k] = v
			assert.same ta, tab
			assert.equal nil, a\next!

	describe 'HashVIter', ->
		import HashVIter from iter

		it 'works', ->
			tab = {a: 1, b: 2, c: 3, d: 5}
			vals = {1, 2, 3, 5}

			a = HashVIter tab
			ta = {}
			for i=1, 4
				ta[i] = a\next!
			table.sort ta
			assert.same ta, vals
			assert.equal nil, a\next!

	describe 'ArrayKIter', ->
		import ArrayKIter from iter

		it 'works', ->
			a = ArrayKIter {5, 7, 3, 4, 6}
			assert.returnsit a, {1, 2, 3, 4, 5}

			b = ArrayKIter {}
			assert.equal nil, b\next!

	describe 'ArrayKVIter', ->
		import ArrayKVIter from iter

		it 'works', ->
			testontab = (tab) ->
				a = ArrayKVIter tab
				for i, v in ipairs tab
					assert.same {i, v}, a\next!
				assert.equal nil, a\next!

			testontab {}
			testontab {5, 7, 6}
			testontab {'a', -2}

	describe 'ArrayVIter', ->
		import ArrayVIter from iter

		it 'works', ->
			testontab = (tab) ->
				a = ArrayVIter tab
				for v in *tab
					assert.equal v, a\next!
				assert.equal nil, a\next!

			testontab {5, 6, 7, 2}
			testontab {}
			testontab {-2, 'a'}

	describe 'TupleIter', ->
		import TupleIter from iter
		tuple = require 'moonutil.tuple'

		it 'works', ->
			a = TupleIter tuple.new 1, 2, 3, 4
			assert.returnsit a, {1, 2, 3, 4}

			b = TupleIter tuple.new!
			assert.equal nil, b\next!

			c = TupleIter tuple.new 'a', 'b', 'c'
			assert.returnsit c, {'a', 'b', 'c'}

	describe 'functional stuff', ->
		import ArrayKVIter, ArrayVIter from iter
		tab = {4, 5, 3, 6}
		tab2 = {'a', 'b', 'c'}

		it 'accepts freestanding next', ->
			import next from iter

			a = ArrayKVIter {'a', 'b'}
			assert.same {1, 'a'}, next a
			assert.same {2, 'b'}, next a
			assert.equal nil, next a

			b = ArrayVIter {4, 5, 3}
			assert.equal 4, next b
			assert.equal 5, next b
			assert.equal 3, next b
			assert.equal nil, next b

		it 'can be mapped', ->
			import map from iter

			a = map (ArrayVIter {4, 5, 6}), => 2*@
			assert.returnsit a, {8, 10, 12}

			b = (ArrayVIter {4, 5, 6})\map => 2*@
			assert.returnsit b, {8, 10, 12}

		it 'can be filtered', ->
			import filter from iter

			a = filter (ArrayVIter tab), => @>4
			assert.returnsit a, {5, 6}

			b = (ArrayVIter tab)\filter => @>4
			assert.returnsit b, {5, 6}

		it 'can be spied on', ->
			import tee from iter

			ta = {}
			a = tee (ArrayVIter tab), => table.insert ta, @
			assert.returnsit a, tab
			assert.same ta, tab

			tb = {}
			b = (ArrayVIter tab)\tee => table.insert tb, @
			assert.returnsit b, tab
			assert.same tb, tab

		it 'can be finalized', ->
			import finalize from iter

			ca = false
			a = finalize (ArrayVIter tab), -> ca = true
			assert.returnsit a, tab
			assert.equal ca, true

			cb = false
			b = (ArrayVIter tab)\finalize -> cb = true
			assert.returnsit b, tab
			assert.equal cb, true

		it 'can be limited', ->
			import limit from iter

			a = limit (ArrayVIter tab), 2
			assert.returnsit a, {4, 5}

			b = (ArrayVIter tab)\limit 2
			assert.returnsit b, {4, 5}

		it 'can have values skipped', ->
			import skip from iter

			a = skip (ArrayVIter tab), 2
			assert.returnsit a, {3, 6}

			b = (ArrayVIter tab)\skip 2
			assert.returnsit b, {3, 6}

		it 'can be looped', ->
			import loop from iter

			a = loop (ArrayVIter tab), 2
			assert.returnsit a, {4, 5, 3, 6, 4, 5, 3, 6}

			b = loop (ArrayVIter tab)
			for i=1, 5
				for v in *tab
					assert.equals v, b\next!

			c = (ArrayVIter tab)\loop 2
			assert.returnsit c, {4, 5, 3, 6, 4, 5, 3, 6}

			d = (ArrayVIter tab)\loop!
			for i=1, 5
				for v in *tab
					assert.equals v, d\next!

		it 'can be zipped', ->
			import zip from iter

			a = zip (ArrayVIter tab), (ArrayVIter tab)
			assert.returnsit a, {{4, 4}, {5, 5}, {3, 3}, {6, 6}}

			b = zip (ArrayVIter tab), (ArrayVIter tab2)
			assert.returnsit b, {{4, 'a'}, {5, 'b'}, {3, 'c'}}

			c = (ArrayVIter tab)\zip ArrayVIter tab
			assert.returnsit c, {{4, 4}, {5, 5}, {3, 3}, {6, 6}}

			d = (ArrayVIter tab)\zip ArrayVIter tab2
			assert.returnsit d, {{4, 'a'}, {5, 'b'}, {3, 'c'}}

		it 'can be concatenated', ->
			import cat from iter

			a = cat (ArrayVIter tab)
			assert.returnsit a, tab

			b = cat (ArrayVIter tab), (ArrayVIter tab2)
			assert.returnsit b, {4, 5, 3, 6, 'a', 'b', 'c'}

			c = cat (ArrayVIter tab), (ArrayVIter tab2), (ArrayKVIter tab)
			assert.returnsit b, {4, 5, 3, 6, 'a', 'b', 'c', {1, 4}, {2, 5}, {3, 3}, {4, 6}}

			d = (ArrayVIter tab)\cat!
			assert.returnsit d, tab

			e = (ArrayVIter tab)\cat (ArrayVIter tab2)
			assert.returnsit e, {4, 5, 3, 6, 'a', 'b', 'c'}

			f = (ArrayVIter tab)\cat (ArrayVIter tab2), (ArrayKVIter tab)
			assert.returnsit f, {4, 5, 3, 6, 'a', 'b', 'c', {1, 4}, {2, 5}, {3, 3}, {4, 6}}

	describe 'iteration', ->
		import ArrayVIter from iter
		tab = {4, 5, 3, 6}

		it 'can be turned into a lua function', ->
			import tofn from iter

			a = tofn (ArrayVIter tab)
			assert.equal 4, a!
			assert.equal 5, a!
			assert.equal 3, a!
			assert.equal 6, a!
			assert.equal nil, a!

			b = (ArrayVIter tab)\tofn!
			assert.equal 4, b!
			assert.equal 5, b!
			assert.equal 3, b!
			assert.equal 6, b!
			assert.equal nil, b!

		it 'can be turned into a lua iterator', ->
			import tolua from iter

			a, ca = tolua (ArrayVIter tab)
			assert.equal 4, a ca
			assert.equal 5, a ca
			assert.equal 3, a ca
			assert.equal 6, a ca

			b, cb = (ArrayVIter tab)\tolua!
			assert.equal 4, b cb
			assert.equal 5, b cb
			assert.equal 3, b cb
			assert.equal 6, b cb

		it 'can be iterated with a foreach', ->
			import foreach from iter

			ta = {}
			foreach (ArrayVIter tab), => table.insert ta, @
			assert.same ta, tab

			tb = {}
			(ArrayVIter tab)\foreach => table.insert tb, @
			assert.same tb, tab

	describe 'collection', ->
		import ArrayVIter, HashKVIter from iter
		tab = {4, 5, 3, 6}
		dic = {a: 1, b: 2, c: 3, d: -1}

		it 'can be collected into an array table', ->
			import collect from iter

			ta = collect (ArrayVIter tab)
			assert.same ta, tab

			tb = (ArrayVIter tab)\collect!
			assert.same tb, tab

		it 'can be collected into a dict table', ->
			import collectkv from iter

			ta = collectkv (HashKVIter dic)
			assert.same ta, dic

			tb = (HashKVIter dic)\collectkv!
			assert.same tb, dic

		it 'can be collected into a set', ->
			import collectset from iter

			sa = collectset (ArrayVIter tab)
			for v in *tab
				assert.equal true, sa\has v

			sb = (ArrayVIter tab)\collectset!
			for v in *tab
				assert.equal true, sb\has v

		it 'can be counted', ->
			import count from iter

			ca = count (ArrayVIter tab)
			assert.equal ca, 4

			cb = (ArrayVIter tab)\count!
			assert.equal cb, 4

		it 'can be folded', ->
			import fold from iter
			add = (a, b) -> a+b

			fa = fold (ArrayVIter tab), add
			assert.equal fa, 18

			fb = (ArrayVIter tab)\fold add
			assert.equal fb, 18

