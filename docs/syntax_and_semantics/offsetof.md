# offsetof

An `offsetof` expression returns the byte offset of a field in an instance of a class or struct.

There are two forms of `offsetof` expressions. The first form accepts any type as first argument and an instance variable name prefixed by an `@` as second argument, and returns the byte offset of that instance variable relative to an instance of the given type:

```crystal
struct Foo
  @x = 0_i64
  @y = 34_i8
  @z = 42_u16
end

offsetof(Foo, @x) # => 0
offsetof(Foo, @y) # => 8
offsetof(Foo, @z) # => 10
```

The second form accepts any [`Tuple`](https://crystal-lang.org/api/Tuple.html) instance type as first argument and an integer literal index as second argument, and returns the byte offset of the corresponding tuple element relative to an instance of the given type:

```crystal
offsetof(Tuple(Int64, Int8, UInt16), 0) # => 0
offsetof(Tuple(Int64, Int8, UInt16), 1) # => 8
offsetof(Tuple(Int64, Int8, UInt16), 2) # => 10
```

This is a low-level primitive and only useful if a C API needs to directly interface with the data layout of a Crystal type.
