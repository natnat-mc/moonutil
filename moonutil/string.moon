import sub, format, gsub, gmatch, match, rep from string
import clone from require 'moonutil.table'
unpack or=table.unpack
tconcat=table.concat
string=clone string

epat= (pat) ->
	((gsub pat, "[%%.+*^$-]", (a) -> '%'..a))
string.epat=epat

grep= (pat, val) =>
	gsub (epat pat), val
string.grep=grep

concat= (...) ->
	tconcat {...}, 1, select '#', ...
string.concat=concat

contains= (val) =>
	(match @, epat val)!=nil
string.contains=contains

string

