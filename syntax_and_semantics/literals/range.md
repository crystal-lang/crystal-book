# Range

A [Range](http://crystal-lang.org/api/Range.html) represents an interval between two values. It is typically constructed with a range literal, consisting of two or three dots:

* `x..y`: Two dots denote an inclusive range, including `x` and `y` and all values in between (in mathematics: `[x, y]`) .
* `x...y`: Three dots denote an exclusive range, including `x` and all values up to but not including `y` (in mathematics: `[x, y)`).

```cr
(0..5).to_a # => [0, 1, 2, 3, 4, 5]
(0...5).to_a # => [0, 1, 2, 3, 4]
```

NOTE: Range literals are often wrapped in parentheses, for example if it is meant to be used as the receiver of a call. `0..5.to_a` without parentheses would be semantically equivalent to `0..(5.to_a)` because method calls and other operators have higher precedence than the range literal.

An easy way to remember which one is inclusive and which one is exclusive it to think of the extra dot as if it pushes *y* further away, thus leaving it outside of the range.

The literal `x..y` is semantically equivalent to the explicit constructor `Range.new(x, y)` and `x...y` to `Range.new(x, y, true)`.

The begin and end values do not necessarily need to be of the same type: `true..1` is a valid range, although pretty useless `Enumerable` methods won't work with incompatible types. They need at least to be comparable.

Ranges with `nil` as begin are called begin-less and `nil` as end are called end-less ranges. In the literal notation, `nil` can be omitted: `x..` is an end-less range starting from `x`, and `..x` is an begin-less range ending at `x`.

```cr
numbers = [1, 10, 3, 4, 5, 8]
numbers.select(6..) # => [10, 8]
numbers.select(..6) # => [1, 3, 4, 5]

numbers[2..] = [3, 4, 5, 8]
numbers[..2] = [1, 10, 3]
```

A range that is both begin-less and end-less is valid and can be expressed as `..` or `...` but it's typically not very useful.
