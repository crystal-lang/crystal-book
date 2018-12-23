# Range

A [Range](http://crystal-lang.org/api/Range.html) is typically constructed with a range literal:

```crystal
x..y  # an inclusive range, in mathematics: [x, y]
x...y # an exclusive range, in mathematics: [x, y)

# Example:
(0..5).to_a # => [0, 1, 2, 3, 4, 5]
(0...5).to_a # => [0, 1, 2, 3, 4]
```

An easy way to remember which one is inclusive and which one is exclusive it to think of the extra dot as if it pushes *y* further away, thus leaving it outside of the range.
