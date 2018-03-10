# StaticArray

It is possible to create an Array with fixed size, that is called a [StaticArray](http://crystal-lang.org/api/StaticArray.html). Unlike a plain [Array](http://crystal-lang.org/api/Array.html) the number of elements should be provided while initializing.

```crystal
Triplet = StaticArray(Int32, 3)           # => ok
triple_two = Triplet.new(2)               # => StaticArray[2, 2, 2]

# or just
triple_two = StaticArray(Int32, 3).new(2) # => StaticArray[2, 2, 2]
```

A static array constructor can take a block, which will be called once for each index of the array, assigning the block's value in that index.

```crystal
StaticArray(Int32, 3).new { |i| i * 2 } # => StaticArray[0, 2, 4]
```

The order of elements of a static array or elements themselves can be changed just like for a plain array.

```crystal
static = StaticArray[1, "foo", 2] # => StaticArray[1, "foo", 2]
static[2] = "bar"
static                            # => StaticArray[1, "foo", "bar"]
static.shuffle!                   # => StaticArray["bar", "foo", 1]
```

But any attempt to alter the size of a static array, will raise an exception.

```crystal
static = StaticArray[1, "foo"] # => StaticArray[1, 2]
static[2] = 2                  # => Index out of bounds (IndexError)
```
