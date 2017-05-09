# Comparisons

Comparing Strings

```crystal
"a" == "a"		# true : Bool
"a" === "a"		# true : Bool
"a" == "b"		# false : Bool
"a" === "b"		# false : Bool

"a" =~ /a/ # => 0
"a" =~ /b/ # => nil

"a" !~ /a/ # => false
"a" !~ /b/ # => true

"a" <=> "b"		# -1 : Int32
"a" <=> "a"		# 0 : Int32
"b" <=> "a"		# 1 : Int32
```

Comparing Arrays

```crystal
["a", "b", "c"] == ["a", "b", "c"]		# true : Bool
["a", "b", "c"] === ["a", "b", "c"]		# true : Bool
["A", "B", "C"] == ["a", "b", "c"]		# false : Bool
[1, 2, 3] == [1, 2, 3]		# true : Bool
[1, 2, 3] === [1, 2, 3]		# true : Bool
[1, 2, 3] == [3, 2, 1]		# false : Bool
[1, 2, 3] === [3, 2, 1]		# false : Bool

[1, 2] <=> [1, 2]			# 0 : Int32
[1, 2] <=> [1, 2, 3]		# -1 : Int32
[1, 2] <=> [1]				# 1 : Int32
```

<!-- TODO: consider other comparisons like >, <, etc -->
<!-- TODO: comparing tuples and other types -->
