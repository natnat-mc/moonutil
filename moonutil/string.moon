import sub, format, gsub, gmatch, match, rep from string
import clone from require 'moonutil.table'
unpack or=table.unpack
tconcat=table.concat
string=clone string

string.epat= (pat) ->
	((gsub pat, "[%%.+*^$-]", (a) -> '%'..a))
epat=string.epat

string.grep= (pat, val) =>
	gsub (epat pat), val

string.concat= (...) ->
	tconcat {...}, 1, select '#', ...

string.contains= (val) =>
	(match @, epat val)!=nil

string.split= (pat, n=math.huge) =>
	arr, i={}, 1
	idx=1
	for b, e in gmatch @, "()#{pat}()"
		break if i>n
		arr[i], i, idx=(sub @, idx, b-1), i+1, e
	arr[i]=sub @, idx
	arr, i+1

string

