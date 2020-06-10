tuple = require 'moonutil.tuple'

describe 'tuple', ->
	describe 'new', ->

		it 'creates tuples correctly', ->
			tab = {}
			for i=0, 50
				tab[i] = i unless i==0
				tup = tuple.new (table.unpack or unpack) tab
				assert.equal i, select '#', tup!
				assert.same tab, {tup!}

	describe 'get', ->

		it 'gets the right item from the tuple', ->
			b = -> 1, 4, 9, 16, 25
			for i=1, 5
				assert.equal (tuple.get b, i), i*i

			c = -> 'a', 'b'
			assert.equal 'a', tuple.get c, 1
			assert.equal 'b', tuple.get c, 2

	describe 'len', ->

		it 'returns the length of the tuple', ->
			a = ->
			b = -> 'a'
			c = -> 1, 2, 3, 2, 1
			d = -> nil

			assert.equal 0, tuple.len a
			assert.equal 1, tuple.len b
			assert.equal 5, tuple.len c
			assert.equal 1, tuple.len d

	describe 'set', ->

		it "doesn't mutate the original tuple", ->
			a = -> 1
			tuple.set a, 1, 2
			assert.equal a!, 1

			b = tuple.new 'a', 'b', 'c'
			tuple.set b, 2, 2
			assert.equal 'b', tuple.get b, 2

		it 'returns a new tuple with the new value', ->
			a = tuple.new 'a', 'b', 'c'
			b = tuple.set a, 2, 'd'
			assert.equal 3, tuple.len b
			assert.equal 'a', tuple.get b, 1
			assert.equal 'd', tuple.get b, 2
			assert.equal 'c', tuple.get b, 3

