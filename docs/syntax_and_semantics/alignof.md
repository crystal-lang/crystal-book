# alignof

The `alignof` expression returns an `Int32` with the ABI alignment in bytes of a given type. For example:

```crystal
alignof(Int32) # => 4
alignof(Int64) # => 8

struct Foo
  def initialize(@x : Int8, @y : Int16)
  end
end

@[Extern]
@[Packed]
struct Bar
  def initialize(@x : Int8, @y : Int16)
  end
end

alignof(Foo) # => 2
alignof(Bar) # => 1
```

For [Reference](https://crystal-lang.org/api/Reference.html) types, the alignment is the same as the alignment of a pointer:

```crystal
# On a 64-bit machine
alignof(Pointer(Int32)) # => 8
alignof(String)         # => 8
```

This is because `Reference`'s memory is allocated on the heap and a pointer to it is passed around. To get the effective alignment of a class, use [instance_alignof](instance_alignof.md).

The argument to alignof is a [type](type_grammar.md) and is often combined with [typeof](typeof.md):

```crystal
a = 1
alignof(typeof(a)) # => 4
```
